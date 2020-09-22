json.(@polls) { |poll| json.partial! 'api/students_api/polls/poll', poll: poll }
