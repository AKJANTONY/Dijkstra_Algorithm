<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
  <title>Dijkstra</title>
  
  <script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.4.11/d3.min.js" charset="utf-8"></script>
  <script src="js/dijkstrademo.js"></script>

<style> 
  .vertex circle {
    stroke: #bdbdbd;
    fill: white;
    stroke-width: 2;
  }
  .vertex.visited circle {
    fill: #fdbb84;
  }
  .vertex.from circle{
    stroke: green;
    stroke-width: 2;
  }
  .vertex.to circle {
    stroke: blue;
    stroke-width: 2;
  }
  .vertex.path circle {
    stroke: #2ca25f;
    fill: #2ca25f;
  }
  .vertex.from.path circle {
    fill: green;
    stroke: #2ca25f;
    stroke-width: 4;
  }
  .vertex.to.path circle {
    stroke: #2ca25f;
    stroke-width: 4;
  }
  .edge line {
    stroke: #bdbdbd;
    stroke-width: 3;
  } 
  .edge.path line {
    stroke: #2ca25f;
    stroke-width: 7;
  }
  text.weight {
    font-size: 10px;
    font-weight: bold;
  }
  text.distance {
    font-size: 10px;
    font-weight: bold;
  }
</style>

</head>
<body style="background-color: #27b0a7;">


   <a href="/home" style="color: #2230d2;">Go to Home</a> <br /> <br />
  <!-- Rows:<input id="rows" type="number" min="3", max="15" width="40" value="15"/>
  Columns:<input id="cols" type="number" min="3", max="25" width="40" value="20"/> -->

  <div id="chart" style="text-align: center;"></div>

<script>

  var dijkstra = new dijkstra().interval(1).rows(12).cols(20);
  
  var svg = d3.select("#chart").append("svg")
    .attr("width", 1200)
    .attr("height", 550);

  var repaint = function() {

    var xscale = d3.scale.linear()
      .domain([0, dijkstra.cols() * 30])
      .range([0, svg.attr("width")]);

    var yscale = d3.scale.linear()
      .domain([0, dijkstra.rows() * 30])
      .range([0, svg.attr("height")]);
    
    var radius = (svg.attr("width") > svg.attr("height")) ? yscale(7) : xscale(7);

    // Edges
    var edge = svg.selectAll(".edge").data(dijkstra.edges(), function(e) { return e.id(); });

    edge.enter()
      .append("g")
      .classed("edge", true)
      .attr("transform", function(d) { return "translate(" + xscale( (0.5 + d.source().col()) * 30) + "," + yscale( (0.5 + d.source().row()) * 30) + ")" } )
      .each(function(d) {
        d3.select(this).append("line")
          .attr("id", function(d) { return d.id() })
          .attr( "x1", function(d) { return 0 })
          .attr( "y1", function(d) { return 0 })
          .attr( "x2", function(d) { return xscale((d.destination().col() - d.source().col() ) * 30); })
          .attr( "y2", function(d) { return yscale((d.destination().row() - d.source().row() ) * 30); })
          .classed("path", function(d) { return d.path(); });

        d3.select(this).append("text")
          .attr("text-anchor", "middle") 
          .attr("dominant-baseline", "central") 
          .attr("x", function(d) { return xscale( (d.destination().col() - d.source().col()) / 2 * 30 ) } )
          .attr("y", function(d) { return yscale( (d.destination().row() - d.source().row()) / 2 * 30 ) })
          .text(function(d) { return d.weight(); })
          .classed("distance", true);
      });

    edge.each(function(d) {
      d3.select(this)
        .classed("path", function(d) { return d.path(); })
    })

    // Vertices
    var vertex = svg.selectAll(".vertex").data(dijkstra.vertices(), function(v) { return v.id(); });
    //console.log(data);
    console.log("---------------");
    console.log(vertex);
    vertex.enter()
      .append("g")
      .classed("vertex", true)
      .attr("transform", function(d) { return "translate(" + xscale( (0.5 + d.col()) * 30) + "," + yscale( (0.5 + d.row()) * 30) + ")" } )
      .each(function(d) {
        d3.select(this).append("circle")
          .attr("id", function(d) { return d.id() })
          .attr("r", function(d) { return radius; })
          .classed("from", function(d) { return dijkstra.from() != null && d.id() == dijkstra.from().id(); })
          .classed("to", function(d) { return dijkstra.to() != null && d.id() == dijkstra.to().id(); })
          .classed("visited", function(d) { return d.visited(); })
          .classed("path", function(d) { return d.path(); });

        d3.select(this).append("text")
          .attr("text-anchor", "middle") 
          .attr("dominant-baseline", "central") 
          .text(function(d) { return d.distance() != Infinity ? d.distance() : ""; })
          .classed("weight", true);
      }).on("click", function() {
      if (!dijkstra.running()) {
        var v = d3.select(this).data()[0];
        if (dijkstra.from() == null) {
          dijkstra.from(v);
        } else {
          if (dijkstra.to() == null) {
            dijkstra.to(v);
          } else {
            dijkstra.to(null);
            dijkstra.from(v);
          }
        }
      }
    });

    vertex.each(function(d) {
      d3.select(this)
        .classed("from", function(d) { return dijkstra.from() != null && d.id() == dijkstra.from().id(); })
        .classed("to", function(d) { return dijkstra.to() != null && d.id() == dijkstra.to().id(); })
        .classed("visited", function(d) { return d.visited(); })
        .classed("path", function(d) { return d.path(); })

      d3.select(this).select("text")
        .text(function(d) { return d.distance() != Infinity ? d.distance() : ""; })
    })

  }

  dijkstra.onStart(repaint).onStep(repaint).start();


  d3.select("#rows").on("change",function() { 
    d3.selectAll(".vertex").remove();
    d3.selectAll(".edge").remove();
    dijkstra.rows(+this.value).init();
  });
  d3.select("#cols").on("change",function() { 
    d3.selectAll(".vertex").remove();
    d3.selectAll(".edge").remove();
    dijkstra.cols(+this.value).init();
  });
  

</script>

</body>
</html>