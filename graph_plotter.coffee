#
# @author Michele Mattioni
#

class BarGraph
  constructor: (@data, chart_id) ->
    @width = 700
    @height = 300
    @barWidth = 40
        # Base vis layer
    @vis = d3.select(chart_id)
        .append('svg:svg')
        .attr('width', @width)
        .attr('height', @height)
    
  
  # we incorporate this variable in the class defination to get to them later on   
  setScale: (@xMinDomain, @xMaxDomain, @yMinDomain, @yMaxDomain, @xPadding, @yPadding)->
    @xScale  = d3.scale.linear().domain([@xMinDomain, @xMaxDomain]).range [0, @width - @xPadding]
    @yScale  = d3.scale.linear().domain([@yMinDomain, @yMaxDomain]).range [0, @height - @yPadding]
  
  createBars: ->   
    @vis.selectAll('rect')
          .data(@data)
          .enter()
          .append("svg:rect")
          .attr("fill-opacity", 0.0001)
          .attr("class", (datum) => "year-" + datum.year)
          .attr("x", (datum, index) => @xScale(index * @barWidth))
          .attr("y", (datum) => @height - @yPadding - @yScale(datum.votes))
          .attr("width", @barWidth)
          .attr("height",(datum) => @yScale(datum.votes))
          .append("svg:title")
          .text((datum) => datum.percent + "%")

  colorBar: ->
    @vis.selectAll('rect')
        .transition()
        .duration(3000)
        .attr("fill-opacity", 1)
                   
  createText: ->
    @vis.selectAll("text")
        .data(@data)
        .enter()
        .append("text")
        .text((datum) =>  datum.candidate.split(" ")[-1..][0])
        .attr("text-anchor", "start")
        .attr("x", (datum, index) =>  @xScale(index * @barWidth))
        .attr("y", (datum) => @height )
    
    
class CircleGraph
  constructor: (@data, chart_id) ->    
    # svg init
    @width = 700
    @height = 300
    @circleSpace = 30
        # Base vis layer
    @vis = d3.select(chart_id)
        .append('svg:svg')
        .attr('width', @width)
        .attr('height', @height)
       
  # we incorporate this variable in the class defination to get to them later on   
  setScale: (@xMinDomain, @xMaxDomain, @yMinDomain, @yMaxDomain, @xPadding, @yPadding)->
    @xScale  = d3.scale.linear().domain([@xMinDomain, @xMaxDomain]).range [100, @width - @xPadding]
    @yScale  = d3.scale.linear().domain([@yMinDomain, @yMaxDomain]).range [0, @height - @yPadding]
    
  thousand: d3.format(",")
  
  createCircle: (meanVote)->
    @vis.selectAll('circle')
        .data(@data)
        .enter()
        .append("svg:circle")
        .attr("class", (datum) => "year-" + datum.year)
        .attr("cx", (datum, index) => @xScale(index * @circleSpace))
        .attr("cy", @yScale(meanVote))
        .attr("r", (datum) => (@yScale(datum.votes)))
        
  createYearsText: ->
    @vis.selectAll(".legend")
        .data(@data)
        .enter()
        .append("text")
        .attr("class", "legend")
        .attr("class", (datum) => "year-" + datum.year + "-text")
        .text((datum) =>  datum.year)
        .attr("text-anchor", "middle")
        .attr("x", (datum, index) =>  @xScale(index * @circleSpace))
        .attr("y", (datum) => @height)
        
  createVotesText: (meanValue) ->
    @vis.selectAll("votes")
        .data(@data)
        .enter()
        .append("text")
        .attr("class", "votes")
        .text((datum) =>  @thousand(datum.votes))
        .attr("text-anchor", "middle")
        .attr("x", (datum, index) => @xScale(index * @circleSpace))
        .attr("y", @yScale(meanValue))
        
    
    
d3.json "assets/primariePdData.json", (data) =>
  # Getting the domains right
  votes = ( d["votes"] for d in data )
  #console.log(d["year"], d["candidate"], d["votes"]) for d in data
  textHeight = 20
  barGraph = new BarGraph(data, "#graph-bar")
  
  barGraph.setScale(xMinDomain=0, xManDomain=barGraph.barWidth * barGraph.data.length, 
                    yMinDomain=0, yMaxdomain=d3.max(votes), 
                    xPadding=0, yPadding=textHeight)
    
  barGraph.createBars()
  barGraph.createText()
  barGraph.colorBar()
  
  # data processing
  votesPerYear = []
  for datum in data
    year = datum.year
    if votesPerYear.hasOwnProperty(year)
      votesPerYear[year] += datum.votes
    else
      votesPerYear[year] = datum.votes
  years = []
  votesTotal = []
  for year, vote of votesPerYear
    years.push year
    votesTotal.push vote
  arrayYearVote = []
  for year, votes of votesPerYear
    arrayYearVote.push {"year" : parseInt(year), "votes" : votes}
  
  circleGraph = new CircleGraph(arrayYearVote, "#graph-circle")
  circleGraph.setScale(xMinDomain=0, xMaxDomain=circleGraph.data.length * circleGraph.circleSpace,
                       yMinDomain=0, yMaxDomain=3*d3.max(votesTotal),
                       xPadding=0, yPadding=0 
                      )
  
  meanValue = 1.5 * d3.mean(votesTotal)                    
  circleGraph.createCircle(meanValue)
  circleGraph.createVotesText(meanValue)
  circleGraph.createYearsText()
  
      