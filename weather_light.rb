#!/usr/bin/ruby                                                    
# -*- coding: utf-8 -*-

############ weather code 
require "open-uri"
require "json"

url = "http://weather.livedoor.com/forecast/webservice/json/v1?city=130010" # tokyo 


# get weather
s_json = ""
today_telop = ""
begin
  open(url) do |io|
    s_json = io.read
  end
  s_json = JSON.parse(s_json)
  today_telop = s_json["forecasts"][0]["telop"] # 今日の天気
rescue
  # if raise, light error_pin
  error_pin.on
end

############ raspberry pi initialize code
require 'pi_piper'

# 23 = red
# 24 = yellow
# 25 = green

red_pin = PiPiper::Pin.new :pin => 23, :direction => :out
yellow_pin = PiPiper::Pin.new :pin => 24, :direction => :out
green_pin = PiPiper::Pin.new :pin => 25, :direction => :out
error_pin = PiPiper::Pin.new :pin => 22, :direction => :out

red_pin.off
yellow_pin.off
green_pin.off
error_pin.off

begin 
  
  if /雨|雪/ =~ today_telop
    red_pin.on
  end
  
  if /曇/ =~ today_telop
    yellow_pin.on
  end
  
  if /晴/ =~ today_telop
    green_pin.on
  end
  
rescue
  error_pin.on
end
