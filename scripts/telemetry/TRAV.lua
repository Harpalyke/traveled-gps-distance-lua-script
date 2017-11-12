local lastRunTS = 0;
local INTERVAL = 50;

local sensorId = 0x09C7;
local sensorSubID = 0;
local sensorInstance = 0;
local sensorName = "TRAV";
  
local GPS_SENSOR_ID = -1;
local LAST_LOCATION_LAT_VALUE = 0;
local LAST_LOCATION_LON_VALUE = 0;
local TOTAL_DISTANCE_TRAVELED = 0;

local menuList = {
    {
        t = "reset distance",
        f = resetDistance
    }
}

local function getTelemetryId(name)
     local field = getFieldInfo(name)
     if field then
       local fieldId = field['id'];
       if fieldId ~= nil then
         return fieldId;
       else
        return -1;
       end
     else
       return -1
     end
 end
 
 local function geo_distance(lat1, lon1, lat2, lon2)
  if lat1 == nil or lon1 == nil or lat2 == nil or lon2 == nil then
    return nil
  end
  local dlat = math.rad(lat2-lat1)
  local dlon = math.rad(lon2-lon1)
  local sin_dlat = math.sin(dlat/2)
  local sin_dlon = math.sin(dlon/2)
  local a = sin_dlat * sin_dlat + math.cos(math.rad(lat1)) * math.cos(math.rad(lat2)) * sin_dlon * sin_dlon
  local c = 2 * math.atan2(math.sqrt(a), math.sqrt(1-a))
  -- 6378 km is the earth's radius at the equator.
  -- 6357 km would be the radius at the poles (earth isn't a perfect circle).
  -- Thus, high latitude distances will be slightly overestimated
  -- To get miles, use 3963 as the constant (equator again)
  local d = 6378 * c
  return d
end

local function writeValueToDistanceSensor(value) 
  local UNIT_METERS = 9;
  setTelemetryValue(sensorId, sensorSubID, sensorInstance, value, UNIT_METERS, 0, sensorName);
end

local function resetDistance()
  LAST_LOCATION_LAT_VALUE = 0;
  LAST_LOCATION_LON_VALUE = 0;
  TOTAL_DISTANCE_TRAVELED = 0;
end

local function init()
  lastRunTS = 0;
  TOTAL_DISTANCE_TRAVELED = 0;
  GSP_SENSOR_ID = -1;
  LAST_LOCATION_LAT_VALUE = 0;
  LAST_LOCATION_LON_VALUE = 0;
  writeValueToDistanceSensor(0.00);
end

local function run()
  lcd.clear()
  lcd.drawScreenTitle("Gps distance traveled", 1, 1)
  lcd.drawText(10, 20,"Distance traveled: "..string.format("%.2f", TOTAL_DISTANCE_TRAVELED).."m");
  lcd.drawText(10, 40,"Last pos: "..string.format("%.6f", LAST_LOCATION_LAT_VALUE)..", "..string.format("%.6f", LAST_LOCATION_LON_VALUE));
end
local function bg()
  if lastRunTS == 0 or lastRunTS + INTERVAL < getTime() then
    local value = 10;
    if GSP_SENSOR_ID < 0 then
      GPS_SENSOR_ID = getTelemetryId("GPS");
    end
    local updatedGpsSensorValue = getValue(GPS_SENSOR_ID);

    if type(updatedGpsSensorValue) == "table" then
      if updatedGpsSensorValue["lat"] ~= nil and updatedGpsSensorValue["lon"] ~= nil then
        local lat = updatedGpsSensorValue["lat"];
        local lon = updatedGpsSensorValue["lon"];
        if lat ~= 0 and lon ~= 0 then
          --print("lat/lon: ", lat, lon);
          
          if LAST_LOCATION_LAT_VALUE ~= lat or LAST_LOCATION_LON_VALUE ~= lon then
            if LAST_LOCATION_LAT_VALUE ~= 0 and LAST_LOCATION_LON_VALUE ~= 0 then
              local stepDistanceInKm = geo_distance(LAST_LOCATION_LAT_VALUE, LAST_LOCATION_LON_VALUE, lat, lon);
              local distanceInMeters = stepDistanceInKm * 1000;
              TOTAL_DISTANCE_TRAVELED = TOTAL_DISTANCE_TRAVELED + distanceInMeters;
              --print("new distance: ", TOTAL_DISTANCE_TRAVELED);
            end
            LAST_LOCATION_LAT_VALUE = lat;
            LAST_LOCATION_LON_VALUE = lon;
          end
        end
      else
        print("lat or lon null in table");
      end
    end 
    writeValueToDistanceSensor(TOTAL_DISTANCE_TRAVELED);
    lastRunTS = getTime();
  end
end


return { init=init, run=run, background=bg }