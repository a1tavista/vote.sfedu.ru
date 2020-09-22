json.(@stages) { |stage| json.partial! 'api/students_api/stages/stage', stage: stage }
