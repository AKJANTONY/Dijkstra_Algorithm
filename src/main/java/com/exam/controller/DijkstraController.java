package com.exam.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Map.Entry;

import com.exam.model.Graph;
import com.exam.model.Node;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class DijkstraController {

	
	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String homeMethod() {
		System.out.println("login method..........");
		return "login";
	}
	
	@RequestMapping(value = "/home", method = RequestMethod.GET)
	public String homeMethods() {
		return "home";
	}

	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login() {

		return "login";
	}

	@RequestMapping(value = "/admin", method = RequestMethod.POST)
	public String admin(@RequestParam("username") String username, @RequestParam("password") String password, Model model) {
		System.out.println(username + "   " + password);

		if (username.equals("admin") && password.equals("admin")) {
			return "home";
		} else {
			model.addAttribute("invalid", "failed");
		}
		return "login";
	}

	@RequestMapping(value = "/disdemo", method = RequestMethod.GET)
	public String showDemo(ModelMap model) {
		return "dijkstrademo";
	}

	@RequestMapping(value = "/dijkstra", method = RequestMethod.GET)
	public String getDijkstra(Model model) {
		Node n1 = new Node("Forest_Park");
		Node n2 = new Node("ST_111");
		Node n3 = new Node("Sutphin_Blvd");
		Node n4 = new Node("Jamaica");
		//Node n5 = new Node("Atlantic_Terminal");
		Node n6 = new Node("Atlantic_Avenue");
		Node n7 = new Node("Kings_Highway");
		//Node n8 = new Node("Kings_Hwy");
		Node n9 = new Node("Fillmore_Av_E_32_St");
		Node n10 = new Node("Marine_Park");
		
		
		// Broadway_Junction 21, Nostrand_Av 2, Nostrand_Av_Fulton_St 36, Nostrand_Av_R 14
		Node n11 = new Node("Broadway_Junction");
		//Node n12 = new Node("Nostrand_Av");
		Node n13 = new Node("Nostrand_Av_Fulton_St");
		Node n14 = new Node("Nostrand_Av_R");
		
		// Jay_St_MetroTech 15, DeKalb Av 3, Kings Highway 17
		Node n15 = new Node("Jay_St_MetroTech");
		Node n16 = new Node("DeKalb_Av");

		n1.addDestination(n2, 22);
		n2.addDestination(n3, 5);
		n3.addDestination(n4, 2);
		n4.addDestination(n6, 23);
		//n5.addDestination(n6, 3);
		n6.addDestination(n7, 15);
		n7.addDestination(n9, 9);
		//n8.addDestination(n9, 8);
		n9.addDestination(n10, 4);
		
		n2.addDestination(n11, 21);
		n11.addDestination(n13, 8);
		//n12.addDestination(n13, 2);
		n13.addDestination(n14, 36);
		n14.addDestination(n10, 14);
		
		n14.addDestination(n15, 15);
		n15.addDestination(n16, 3);
		n16.addDestination(n7, 17);

		Graph graph = new Graph();

		graph.addNode(n1);
		graph.addNode(n2);
		graph.addNode(n3);
		graph.addNode(n4);
		//graph.addNode(n5);
		graph.addNode(n6);
		graph.addNode(n7);
		//graph.addNode(n8);
		graph.addNode(n9);
		graph.addNode(n10);
		graph.addNode(n11);
		//graph.addNode(n12);
		graph.addNode(n13);
		graph.addNode(n14);
		graph.addNode(n15);
		graph.addNode(n16);

		Map<String, Integer> hm = new HashMap<String, Integer>();

		for (Node n : graph.getNodes()) {

			for (Map.Entry<Node, Integer> s : n.getAdjacentNodes().entrySet()) {
				hm.put(n.getName() + s.getKey().getName(), s.getValue());
				// System.out.println(n.getName() + s.getKey().getName() + " " + s.getValue());
			}
		}

		ArrayList<HashMap<String, String>> alllist = new ArrayList<HashMap<String, String>>();

		HashMap<String, String> allnodes = null;
		for (Node n : graph.getNodes()) {
			allnodes = new HashMap<String, String>();
			allnodes.put("nodes", n.getName());
			System.out.print("nodes :" + n.getName() + " ");
			for (Node l : graph.getNodes()) {
				String name = n.getName() + l.getName();
				if (hm.containsKey(name)) {
					allnodes.put(l.getName(), "1");
					System.out.print(l.getName() + " : 1 ");
				} else {
					System.out.print(l.getName() + " : - ");
					allnodes.put(l.getName(), "-");
				}
			}
			alllist.add(allnodes);
			System.out.println("");
		}

		List<JSONObject> jsonObj = new ArrayList<JSONObject>();

		for (HashMap<String, String> data : alllist) {
			JSONObject obj = new JSONObject(data);
			jsonObj.add(obj);
		}

		JSONArray test = new JSONArray(jsonObj);

		// System.out.println(test.toString());

		ObjectMapper objectMapper = new ObjectMapper();
		String json = null;
		try {
			json = objectMapper.writeValueAsString(hm);
			// System.out.println(json);
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}

		// to get shortest path
		graph = calculateShortestPathFromSource(graph, n1);

		Map<String, Integer> shortestPath = new HashMap<String, Integer>();
		for (Node n : graph.getNodes()) {
			for (Node s : n.getShortestPath()) {
				shortestPath.put(s.getName(), s.getDistance());
			}
		}
		System.out.println(shortestPath);

		model.addAttribute("distance", json);
		model.addAttribute("jsondata", test);
		model.addAttribute("shortestPath", shortestPath);

		return "route";
	}

	public Graph calculateShortestPathFromSource(Graph graph, Node source) {
		source.setDistance(0);

		Set<Node> settledNodes = new HashSet<>();
		Set<Node> unsettledNodes = new HashSet<>();
		System.out.println(source.getName() + "  " + source.getDistance());
		unsettledNodes.add(source);

		while (unsettledNodes.size() != 0) {
			Node currentNode = getLowestDistanceNode(unsettledNodes);
			unsettledNodes.remove(currentNode);
			for (Entry<Node, Integer> adjacencyPair : currentNode.getAdjacentNodes().entrySet()) {
				Node adjacentNode = adjacencyPair.getKey();
				Integer edgeWeight = adjacencyPair.getValue();
				if (!settledNodes.contains(adjacentNode)) {
					calculateMinimumDistance(adjacentNode, edgeWeight, currentNode);
					unsettledNodes.add(adjacentNode);
				}
			}
			settledNodes.add(currentNode);
		}
		return graph;
	}

	private Node getLowestDistanceNode(Set<Node> unsettledNodes) {
		Node lowestDistanceNode = null;
		int lowestDistance = Integer.MAX_VALUE;
		for (Node node : unsettledNodes) {
			int nodeDistance = node.getDistance();
			if (nodeDistance < lowestDistance) {
				lowestDistance = nodeDistance;
				lowestDistanceNode = node;
			}
		}
		return lowestDistanceNode;
	}

	private void calculateMinimumDistance(Node evaluationNode, Integer edgeWeigh, Node sourceNode) {
		Integer sourceDistance = sourceNode.getDistance();
		if (sourceDistance + edgeWeigh < evaluationNode.getDistance()) {
			evaluationNode.setDistance(sourceDistance + edgeWeigh);
			LinkedList<Node> shortestPath = new LinkedList<>(sourceNode.getShortestPath());
			shortestPath.add(sourceNode);
			evaluationNode.setShortestPath(shortestPath);
		}
	}
}
