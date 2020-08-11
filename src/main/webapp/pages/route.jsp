<html>
<head>
  <title>Dijkstra</title>
<style>

body {
  width: 1024px;
  margin-top: 0;
  margin: auto;
  font-family: "Lato", "PT Serif", serif;
  color: #222222;
  padding: 0;
  font-weight: 300;
  line-height: 33px;
  -webkit-font-smoothing: antialiased;
  background-color : #2a3784;
}

.node {
  stroke: #7f8c8d;
  stroke-width: 1.5px;
  fill: #bdc3c7;
  stroke-dasharray: 2px, 2px;
}


.link {
  stroke: #ecf0f1;
  stroke-opacity: .6;
}

.linktext{
  fill: #95a5a6;
  background-color: #ffffff;
}

text {
    pointer-events: none;
}

.path {    
	color: #19d030;
    text-align: center;
    font-size: 25px;
    font-weight: 700;
    font-family: sans-serif;
    padding-top: 25px;
}

</style>
</head>

<body>
<a href="/home" style="color: #19d030;">Go to Home</a>
<div class="path">Shortest Path Problem With Dijkstra</div>
<script src="http://d3js.org/d3.v3.min.js"></script>
<script src="js2/dijkstra.js"></script>
<script>

var width = 960,
    height = 600;

var color = d3.scale.category20();

var force = d3.layout.force()
    .charge(-4020)
    .linkDistance(90)
    .size([width, height]);

var svg = d3.select("body").append("svg")
    .attr("width", width)
    .attr("height", height);
    
const xah_obj_to_map = ( obj => {
    const mp = new Map;
    Object.keys ( obj ). forEach (k => { mp.set(k, obj[k]) });
    return mp;
});

// --------------------------------------------------
// test

const ob = ${distance}
let map = xah_obj_to_map ( ob );

d3.csv("", function(error, data) {
	data = ${jsondata}
  console.log(data);
  var nodes = [], nodesByName = {}, links = [];
  function addNodeByName(fullname) {
    var name = fullname.split(',')[0];
    if (!nodesByName[name]) {
      var node = {"name":name, "links":[]}
      nodesByName[name] = node;
      nodes.push(node);
      return node;
    }
    else
      return nodesByName[name];
  }
  
  data.forEach(function(d) {
    for (k in d) {
      if (d.hasOwnProperty(k) && k != "nodes" && d[k] < 750) {
    	  console.log(addNodeByName(d["nodes"]));
    	  console.log(addNodeByName(k))
    	  var lin = (map.get(addNodeByName(d["nodes"]).name+addNodeByName(k).name) != null) ? map.get(addNodeByName(d["nodes"]).name+addNodeByName(k).name) : 10;
    	  
        links.push({"source": addNodeByName(d["nodes"]), "target": addNodeByName(k), "value": parseInt(lin), 'id':addNodeByName(d["nodes"]).name+addNodeByName(k).name })
      }
    }
    console.log(links);
  });

  console.log(nodes);
  console.log(links);
  force
      .nodes(nodes)
      .links(links)
      .start();

  var glink = svg.append('g').selectAll(".link")
      .data(links).enter()

  var link = glink.append("line")
      .attr("class", function(d){ return "link "+d.id})
      .style("stroke-width", 3);

  var linktext = glink.append('text')
      .attr("class", function(d){ return "linktext "+d.id})
      .attr('text-anchor', 'middle')
      .style('opacity', 0)
      .text(function(d){ return d.value})

  var gnode = svg.append('g').selectAll(".node")
  	  .style("fill", '#D0E1C3')
      .data(nodes).enter()

  var node = gnode.append("circle")
      .attr("class", function(d){ return 'node '+d.name})
      .attr("r", 15)
      .call(force.drag);

  var nodetext = gnode.append('text')
      .attr('text-anchor', 'middle')
      .attr('dy', '0.35em')
      .attr("class", function(d){ return "nodetext "+d.name})
      .text(function(d){ return d.name})

  
  link.each(function(d) {
      d.source.links.push(d);
      d.selection = d3.select(this);
  });

  node.each(function(d) {
      d.selection = d3.select(this);
  });
  
  force.on("tick", function() {
    link.attr("x1", function(d) { return d.source.x; })
        .attr("y1", function(d) { return d.source.y; })
        .attr("x2", function(d) { return d.target.x; })
        .attr("y2", function(d) { return d.target.y; });

    linktext.attr("x", function(d) { return (d.source.x + d.target.x)/2 ; })
        .attr("y", function(d) { return (d.source.y + d.target.y)/2; })

    nodetext.attr("x", function(d) { return d.x ; })
        .attr("y", function(d) { return d.y; })

    node.attr("cx", function(d) { return d.x; })
        .attr("cy", function(d) { return d.y; });
  });

  
  node.on("mouseover", function(d) {
      d3.select(this).attr('r', 16.5);
      
  });

  node.on("mouseout", function(d) {
      d3.select(this).attr('r', 15);
  });
    
  var dijkstra = d3.dijkstra()
    .nodes(nodes)
    .edges(links);

  node.on("click", dijkstra.start);

 });

</script>
<% 
HttpServletResponse httpResponse = (HttpServletResponse) response;
httpResponse.setHeader("Cache-Control", "public, no-cache, no-store, must-revalidate"); // HTTP 1.1
httpResponse.setHeader("Pragma", "no-cache"); // HTTP 1.0
httpResponse.setDateHeader("Expires", 0); 
%>
<h3 style="color: #19d030;">Shortest Path is ${shortestPath}</h3>
</body>
</html>