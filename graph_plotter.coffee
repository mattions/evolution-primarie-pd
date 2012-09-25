#
# @author Michele Mattioni
#
 

d3.json "assets/primariePdData.json", (data) =>
    console.log(d["year"], d["candidate"], d["votes"]) for d in data
  

graph = d3.select("#graph").
  append("svg:svg").
  attr("width", 400).
  attr("height", 300)

graph.append("svg:rect").
  attr("x", 100).
  attr("y", 100).
  attr("height", 100).
  attr("width", 200)

