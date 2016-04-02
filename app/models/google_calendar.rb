require 'google/api_client'

class GoogleCalendar
  attr_accessor :google2_token

 def initialize(token)
  @google2_token = token
 end

 def create_event(app)
  @event = {
  'summary' => "#{app.subject}",
  'description' => "#{app.reason}",
  'location' => 'Location',
  'start' => { 'dateTime' => Time.now.strftime('%Y-%m-%dT%H:%M:%S%z') },
  'end' => { 'dateTime' => (Time.now + 3.hours).strftime('%Y-%m-%dT%H:%M:%S%z') },
  'attendees' => [ { "email" => 'bob@example.com' }] }

  client = Google::APIClient.new
  service = client.discovered_api('calendar', 'v3')
  client.authorization.access_token = @google2_token
  # client.authorization.access_token = '123'
  @set_event = client.execute(:api_method => service.events.insert,
                        :parameters => {'calendarId' => "jordanovskibojan@gmail.com", 'sendNotifications' => true},
                        :body => JSON.dump(@event),
                        :headers => {'Content-Type' => 'application/json'})
 end
end
