#
# @author Michele Mattioni
#
 

d3.json "assets/primariePdData.json", (data) =>
    # Getting the domains right
    votes = ( d["votes"] for d in data )
    #console.log(d["year"], d["candidate"], d["votes"]) for d in data
    barWidth = 40;
    width = (barWidth + 10) * data.length;
    height = 200;
    
    
    # Scales
    x  = d3.scale.linear().domain([0, data.length]).range [0, width]
    y  = d3.scale.linear().domain([d3.min(votes), d3.max(votes)]).range [0, height]
    
    
    console.log(x(2))
    console.log(y(1444))
    # Base vis layer
    vis = d3.select('#graph')
          .append('svg:svg')
          .attr('width', width)
          .attr('height', height)
     
      # Add path layer
    vis.selectAll('rect')
      .data(data)
      .enter()
      .append("svg:rect")
      .attr("x", (datum, index) =>  x(index))
      .attr("y", (datum) => height - y(datum.votes))
      .attr("width", barWidth)
      .attr("height",(datum) => y(datum.votes))
    
