(function() {

function randomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

/**
 * Vertex 
 */
function Vertex(id, row, col) {
    this._id = id;
    this._edges = [];
    this._row = row;
    this._col = col;
    this._distance = Infinity;
    this._visited = false;
    this._path = false;
}

Vertex.prototype.id = function() {
	return this._id;	
}
Vertex.prototype.edges = function() {
	return this._edges;	
}
Vertex.prototype.row = function() {
	return this._row;	
}
Vertex.prototype.col = function() {
	return this._col;	
}
Vertex.prototype.distance = function(distance) {
	if (!arguments.length) return this._distance;
    this._distance = distance;
    return this;	
}
Vertex.prototype.visited = function(visited) {
	if (!arguments.length) return this._visited;
    this._visited = visited;
    return this;	
}
Vertex.prototype.previous = function(previous) {
	if (!arguments.length) return this._previous;
    this._previous = previous;
    return this;	
}
Vertex.prototype.path = function(path) {
	if (!arguments.length) return this._path;
    this._path = path;
    return this;	
}
Vertex.prototype.isConnected = function(vertex) {
	return this.edges().filter(function(edge) {
		return edge.source().id() == vertex.id() || edge.destination().id() == vertex.id()
	}).length > 0;
}
Vertex.prototype.connect = function(vertex) {
	if( !this.isConnected( vertex ) ) {
        var edge = new Edge(this, vertex );
        this.edges().push(edge);
        vertex.edges().push(edge);
        return edge;
    }
    return null;
}
Vertex.prototype.findEdge = function( dest ) {
        var toRet = null;
        var that = this;
        that.edges().forEach(function(e) {
        	if (toRet == null && (e.destination().id() == dest.id() || e.source().id() == dest.id())) {
        		toRet = e;
        	}
        });
        return toRet;
    }

/**
 * Edge 
 */
function Edge(source, destination) {
    this._id = source.id() + "_" + destination.id();
    this._weight = Math.ceil( Math.random() * 10 );
    this._source = source,
    this._destination = destination;
    this._path = false;
}
Edge.prototype.id = function() {
	return this._id;	
}
Edge.prototype.weight = function(weight) {
	if (!arguments.length) return this._weight;
    this._weight = weight;
    return this;	
}
Edge.prototype.source = function() {
	return this._source;	
}
Edge.prototype.destination = function() {
	return this._destination;	
}
Edge.prototype.opposite = function( vertex ) {
    if( this._source != null && this._source.id() == vertex.id() ) return this._destination;
    else return this._source;
}
Edge.prototype.path = function(path) {
	if (!arguments.length) return this._path;
    this._path = path;
    return this;	
}

/**
 * Dijkstra algorithm 
 */

function dijkstra() {
	this._rows = 10;
	this._cols = 15;
	this._vertices = [];
	this._edges    = [];
	this._unvisited = [];
	this._found = false;
	this._interval = 5;
	this._from = null;
	this._to = null;
	this._running = false;
	this._onStart = function() { console.log("dijkstra start"); }
	this._onStep = function() { console.log("dijkstra step"); }
}

dijkstra.prototype.addVertex = function(vertex) {
	if (vertex != null && vertex != undefined) {
		this._vertices.push(vertex);
		return true;
	}
	return false;
}
dijkstra.prototype.getVertex = function(id) {
	return this._vertices[id];
}
dijkstra.prototype.addEdge = function(edge) {
	if (edge != null && edge != undefined) {
		this._edges.push(edge);
		return true;
	}
	return false;
}
dijkstra.prototype.neighbors = function(vertex) {
	var that = this;
	var neighbors = [];

	var neighbor = function(id) {
		if ( id < that.vertices().length && id >=0) {
			var v = that.getVertex(id);
			if ((v.row() == vertex.row() + 1 || v.row() == vertex.row() - 1 || v.row() == vertex.row()) && 
				(v.col() == vertex.col() + 1 || v.col() == vertex.col() - 1 || v.col() == vertex.col()) ) {
				neighbors.push(v);
			}
		}
	}
	neighbor(vertex.id() + 1);
	neighbor(vertex.id() - 1);
	neighbor(vertex.id() + that.rows());
	neighbor(vertex.id() - that.rows());
	
	return neighbors;
}
dijkstra.prototype.vertices = function(vertices) {
	if (!arguments.length) return this._vertices;
    this._vertices = vertices;
    return this;	
}
dijkstra.prototype.found = function(found) {
	if (!arguments.length) return this._found;
    this._found = found;
    return this;	
}
dijkstra.prototype.running = function(running) {
	if (!arguments.length) return this._running;
    this._running = running;
    return this;	
}
dijkstra.prototype.unvisited = function(unvisited) {
	if (!arguments.length) {
		this._unvisited.sort( function vertexSort(a, b) {
		    if( a == null && b == null ) return 0;
		    if( a == null && b != null ) return 1;
		    if( b == null && a != null ) return -1;
		    if( a.distance() > b.distance() ) return -1;
		    if( a.distance() < b.distance() ) return 1;
		    else return 0;
		} );
		return this._unvisited;
	} else {
    	this._unvisited = unvisited;
    }
    return this;
}

dijkstra.prototype.edges = function(edges) {
	if (!arguments.length) return this._edges;
    this._edges = edges;
    return this;	
}
dijkstra.prototype.rows = function(rows) {
	if (!arguments.length) return this._rows;
    this._rows = rows;
    return this;
}
dijkstra.prototype.cols = function(cols) {
	if (!arguments.length) return this._cols;
    this._cols = cols;
    return this;
}
dijkstra.prototype.from = function(from) {
	if (!arguments.length) return this._from;
    this._from = from;
    if (this._from != null) {
    	this.reset();
    	this._from.distance(0);
    	this.start();
    }
    return this;
}
dijkstra.prototype.to = function(to) {
	if (!arguments.length) return this._to;
    this._to = to;
    if (this._to != null) {
    	this.step();
    }
    return this;
}
dijkstra.prototype.interval = function(interval) {
	if (!arguments.length) return this._interval;
    this._interval = interval;
    return this;
}
dijkstra.prototype.onStart = function(onStart) {
	if (!arguments.length) return this._onStart;
    this._onStart = onStart;
    return this;
}
dijkstra.prototype.onStep = function(onStep) {
	if (!arguments.length) return this._onStep;
    this._onStep = onStep;
    return this;
}
dijkstra.prototype.init = function() {
	var that = this;
	that.from(null);
	that.to(null);
	that.vertices([]);
	that.edges([]);
	that.found(false);
	that.running(false);
	that.start();
}
dijkstra.prototype.reset = function() {
	var that = this;
	that.vertices().forEach(function(v) {
		v.distance(Infinity);
		v.visited(false);
		v.previous(null);
		v.path(false);
	});
	that.edges().forEach(function(e) {
		e.path(false);
	});
}

dijkstra.prototype.start = function() {
	var that = this;

	if (that.from() == null && that.to() == null) {
		// Generate the vertices
		for( var col = 0; col < that.cols(); col++ ) {
		    for( var row = 0; row < that.rows(); row++ ) {
		    	var id = (col*that.rows())+row;
				var vertex = new Vertex(id, row, col);
				that.addVertex(vertex);
		    }
		}
		// Generate the edges
		for( var col = 0; col < that.cols(); col++ ) {
		    for( var row = 0; row < that.rows(); row++ ) {
				var id = (col*that.rows())+row;
	        	var vertex = that.getVertex(id);

	        	var neighbors = that.neighbors(vertex);
	        	var maxEdges = randomInt(1, neighbors.length);
	        	for (var i = 0; i < maxEdges; i++) {
	        		if (vertex.edges().length < 4 && i < neighbors.length) {
		        		var edge = vertex.connect(neighbors[i]);
		        		that.addEdge(edge);
	        		}
	        	}
		    }
		}
		that.reset();
	}
	
	that.unvisited(that.vertices().concat());
	that.found(false);
	that.onStart()();
}

dijkstra.prototype.step = function() {
	var that = this;
	var currentVertex = that.unvisited().pop();

	that.running(true);
	if( currentVertex == that.to() ) {
        that.found(true);
        that.to().path(true);
        that.from().path(true);
    } else {
    	if( currentVertex != null && currentVertex.distance() < Infinity ) {
    		currentVertex.edges().forEach(function(edge){
	        	var distance = currentVertex.distance() + edge.weight();
	        	var vertex = edge.opposite(currentVertex);
	        	if (distance < vertex.distance()) {
	        		vertex.distance(distance);
	        		vertex.previous(currentVertex);
	        	}
	        });
	        currentVertex.visited(true);
	     }
    }
   
    if( that.found() ) {
    	if( that.to().distance() != Infinity ) {
    		var cv = that.to();
	    	var pathBack = "";
	        while( cv != that.from() ) {
	        	cv.path(true);
	        	cv.findEdge(cv.previous()).path(true);
	        	cv = cv.previous();
	        }
    	} else {
    		 console.log( "No path found! Hit the end vertex, but distance=Infinity" );
    	}
        that.onStep()();
        that.running(false);
    } else {
        // Check if there are still things to find
        if( that.unvisited().length > 0 ) {
            // Set a timer to pop and run it again at the next interval
            that.onStep()();
            setTimeout( function() { that.step() }, that.interval());
        } else {
            console.log( "No path found! Ran out of vertices to check." );
            that.running(false);
        }
    }
}


if (typeof define === "function" && define.amd) {
	define(dijkstra);
} else if (typeof module === "object" && module.exports) {
	module.exports = dijkstra;
} else {
	this.dijkstra = dijkstra;
}


}())