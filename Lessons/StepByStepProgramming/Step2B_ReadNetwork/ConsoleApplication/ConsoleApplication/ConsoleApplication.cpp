// ConsoleApplication.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "ConsoleApplication.h"
#include <iostream>
#include <fstream>
#include <list> 
#include <omp.h>
#include <algorithm>
#include <time.h>
#include "CSVParser.h"
#include <functional>
#include<stdio.h>   
#include<tchar.h>
#ifdef _DEBUG
#define new DEBUG_NEW
#endif

TCHAR g_SettingFileName[_MAX_PATH] = _T("./Settings.txt");

FILE* g_pFileDebugLog = NULL;

FILE* g_pFileOutputLog = NULL;

int g_number_of_threads = 4;
int g_shortest_path_debugging_flag = 0;
int g_agent_number;

std::map<int, int> g_internal_node_seq_no_map;  // hush table, map external node number to internal node sequence no. 

class CLink
{
public:
	CLink()  // construction 
	{
		cost = 0;
		BRP_alpha = 0.15f;
		BRP_beta = 4.0f;
		link_capacity = 1000;
		free_flow_travel_time_in_min = 1;
		flow_volume = 0;
		// mfd
		mfd_zone_id = 0;
	}

	int link_seq_no;
	int from_node_seq_no;
	int to_node_seq_no;
	float cost;
	float free_flow_travel_time_in_min;
	int type;
	float link_capacity;
	float flow_volume;
	float travel_time;
	float BRP_alpha;
	float BRP_beta;
	float length;
	// mfd
	int mfd_zone_id;

	void CalculateBRPFunction()
	{
		travel_time = free_flow_travel_time_in_min*(1 + BRP_alpha*pow(flow_volume / max(0.00001, link_capacity), BRP_beta));
		cost = travel_time;
	}

	float get_VOC_ratio()
	{
		return flow_volume / max(0.00001, link_capacity);

	}

	float get_speed()
	{
		return length / max(travel_time, 0.0001) * 60;  // per hour
	}
	// mfd 



};


class CNode
{
public:
	CNode()
	{
		zone_id = 0;
		accessible_node_count = 0;
	}

	int accessible_node_count;

	int node_seq_no;  // sequence number 
	int node_id;      //external node number 
	int zone_id;
	double x;
	double y;

	std::vector<CLink> m_outgoing_node_vector;

};

class CAgent
{
public:
	CAgent()
	{
		PCE_factor = 1.0;
		path_cost = 0;
	}
	int agent_id;
	int origin_node_id;
	int destination_node_id;
	int departure_time_in_min;

	float PCE_factor;  // passenger car equivalent : bus = 3
	float path_cost;
	std::vector<int> path_link_seq_no_vector;
	std::vector<int> path_node_seq_no_vector;


};

std::vector<CNode> g_node_vector;
std::vector<CLink> g_link_vector;
vector<CAgent> g_agent_vector;

int g_number_of_links = 0;
int g_number_of_nodes = 0;


void g_ProgramStop()
{

	cout << "AgentLite Program stops. Press any key to terminate. Thanks!" << endl;
	getchar();
	exit(0);
};
void g_ReadInputData()
{
	g_number_of_nodes = 0;
	g_number_of_links = 0;  // initialize  the counter to 0

	int internal_node_seq_no = 0;
	double x, y;
	// step 1: read node file 
	CCSVParser parser;
	if (parser.OpenCSVFile("input_node.csv", true))
	{
		std::map<int, int> node_id_map;

		while (parser.ReadRecord())  // if this line contains [] mark, then we will also read field headers.
		{

			string name;

			int node_type;
			int node_id;

			if (parser.GetValueByFieldName("node_id", node_id) == false)
				continue;

			if (g_internal_node_seq_no_map.find(node_id) != g_internal_node_seq_no_map.end())
			{
				continue; //has been defined
			}
			g_internal_node_seq_no_map[node_id] = internal_node_seq_no;


			parser.GetValueByFieldName("x", x, false);
			parser.GetValueByFieldName("y", y, false);


			CNode node;  // create a node object 

			node.node_id = node_id;
			node.node_seq_no = internal_node_seq_no;
			parser.GetValueByFieldName("zone_id", node.zone_id);

			node.x = x;
			node.y = y;
			internal_node_seq_no++;

			g_node_vector.push_back(node);  // push it to the global node vector

			g_number_of_nodes++;
			if (g_number_of_nodes % 1000 == 0)
				cout << "reading " << g_number_of_nodes << " nodes.. " << endl;
		}

		cout << "number of nodes = " << g_number_of_nodes << endl;

		fprintf(g_pFileOutputLog, "number of nodes =,%d\n", g_number_of_nodes);
		parser.CloseCSVFile();
	}

	// step 2: read link file 

	CCSVParser parser_link;

	if (parser_link.OpenCSVFile("input_link.csv", true))
	{
		while (parser_link.ReadRecord())  // if this line contains [] mark, then we will also read field headers.
		{
			int from_node_id = 0;
			int to_node_id = 0;
			if (parser_link.GetValueByFieldName("from_node_id", from_node_id) == false)
				continue;
			if (parser_link.GetValueByFieldName("to_node_id", to_node_id) == false)
				continue;

			// add the to node id into the outbound (adjacent) node list

			int internal_from_node_seq_no = g_internal_node_seq_no_map[from_node_id];  // map external node number to internal node seq no. 
			int internal_to_node_seq_no = g_internal_node_seq_no_map[to_node_id];

			CLink link;  // create a link object 

			link.from_node_seq_no = internal_from_node_seq_no;
			link.to_node_seq_no = internal_to_node_seq_no;
			link.link_seq_no = g_number_of_links;
			link.to_node_seq_no = internal_to_node_seq_no;

			parser_link.GetValueByFieldName("link_type", link.type);

			float length = 1; // km or mile
			float speed_limit = 1;
			parser_link.GetValueByFieldName("length", length);
			parser_link.GetValueByFieldName("speed_limit", speed_limit);



			parser_link.GetValueByFieldName("BPR_alpha_term", link.BRP_alpha);
			parser_link.GetValueByFieldName("BPR_beta_term", link.BRP_beta);
			int number_of_lanes = 1;
			float lane_cap = 1000;
			parser_link.GetValueByFieldName("number_of_lanes", number_of_lanes);
			parser_link.GetValueByFieldName("lane_cap", lane_cap);

			link.link_capacity = lane_cap* number_of_lanes;

			link.free_flow_travel_time_in_min = length / speed_limit * 60;
			link.length = length;
			link.cost = length / speed_limit * 60; // min // calculate link cost based length and speed limit // later we should also read link_capacity, calculate delay 


			g_node_vector[internal_from_node_seq_no].m_outgoing_node_vector.push_back(link);  // add this link to the corresponding node as part of outgoing node/link
			g_link_vector.push_back(link);

			g_number_of_links++;

			if (g_number_of_links % 10000 == 0)
				cout << "reading " << g_number_of_links << " links.. " << endl;
		}
	}

	cout << "number of links = " << g_number_of_links << endl;

	fprintf(g_pFileOutputLog, "number of links =,%d\n", g_number_of_links);

	parser_link.CloseCSVFile();

	g_agent_number = 0;
	CCSVParser parser_agent;
	if (parser_agent.OpenCSVFile("input_agent.csv", true))   // read agent as demand input 
	{
		while (parser_agent.ReadRecord())  // if this line contains [] mark, then we will also read field headers.
		{
			CAgent agent;  // create an agent object 
			if (parser_agent.GetValueByFieldName("agent_id", agent.agent_id) == false)
				continue;

			int origin_node_id = 0;
			int destination_node_id = 0;
			parser_agent.GetValueByFieldName("from_origin_node_id", origin_node_id, false);

			agent.origin_node_id = origin_node_id;
			parser_agent.GetValueByFieldName("to_destination_node_id", destination_node_id, false);
			agent.destination_node_id = destination_node_id;

			if (g_internal_node_seq_no_map.find(origin_node_id) == g_internal_node_seq_no_map.end() || g_internal_node_seq_no_map.find(destination_node_id) == g_internal_node_seq_no_map.end())
				continue;

			parser_agent.GetValueByFieldName("departure_time_in_min", agent.departure_time_in_min);

			parser_agent.GetValueByFieldName("PCE", agent.PCE_factor);

			g_agent_vector.push_back(agent);
			g_agent_number++;
		}
	}
	parser_agent.CloseCSVFile();
}

// The one and only application object

CWinApp theApp;

using namespace std;

int main()
{
 

	g_pFileDebugLog = fopen("Debug.txt", "w");
	if (g_pFileDebugLog == NULL)
	{
		cout << "File Debug.txt cannot be opened." << endl;
		g_ProgramStop();
	}
	g_pFileOutputLog = fopen("output_solution.csv", "w");
	if (g_pFileOutputLog == NULL)
	{
		cout << "File output_solution.csv cannot be opened." << endl;
		g_ProgramStop();
	}

	g_ReadInputData();
    return 1;
}
