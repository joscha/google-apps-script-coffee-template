# Coffeescript Google Apps Script template

debug = true

class JSONPHelper
	@response: (error, result, prefix) ->
		ret = []
		if prefix
			ret.push prefix
			ret.push '('

		ret.push Utilities.jsonStringify if error then error: error else success: result

		if prefix
			ret.push ')'

		ContentService.createTextOutput(ret.join '').setMimeType ContentService.MimeType.JSON

class MyClass

	@setup: ->
		Logger.log "Setting up..." if debug
		# Your initializations here - for example setting triggers, etc.
		return

	constructor: ->

	echo: (text) ->
		text
# WebApp-specific events:

doGet = (request) ->
	MyClass.setup()

	m = new MyClass
	switch request.parameter.action
		when 'jsonp'
			JSONPHelper.response null, (hello: 'World!'), request.parameter.callback
		else
			ContentService.createTextOutput m.echo "Works. Check out adding '?action=jsonp&callback=alert' to the URL!"

doPost = (request) ->
	ContentService.createTextOutput 'POST worked!'


# Spreadsheet-specific events:

onOpen = ->

onEdit = (event) ->

onInstall = ->

# Event that can be run from the Script Editor
# This is just a helper until the Google Apps Script Code Editor can deal with 'bla = function() {}' definitions and/or static methods
`function setup() {
  MyClass.setup.apply(MyClass, arguments);
}`