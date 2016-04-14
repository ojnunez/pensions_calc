# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require 'jquery'
#= require 'jquery_ujs'
#= require 'bootstrap-sprockets'
#= require 'chart.min'

doughnutData = [
  {
    value: 300
    color: '#F7464A'
    highlight: '#FF5A5E'
    label: 'Red'
  }
  {
    value: 50
    color: '#46BFBD'
    highlight: '#5AD3D1'
    label: 'Green'
  }
  {
    value: 100
    color: '#FDB45C'
    highlight: '#FFC870'
    label: 'Yellow'
  }
  {
    value: 40
    color: '#949FB1'
    highlight: '#A8B3C5'
    label: 'Grey'
  }
  {
    value: 120
    color: '#4D5360'
    highlight: '#616774'
    label: 'Dark Grey'
  }
]

window.onload = ->
  ctx = document.getElementById('chart-area').getContext('2d')
  window.myDoughnut = new Chart(ctx).Doughnut(doughnutData, responsive: true)
  return