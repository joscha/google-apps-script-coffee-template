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
		Logger.log 'Setting up...' if debug

		# Uncomment this if your script needs to publish itself as a service.
		# Logger.log 'Enabling as a WebApp...' if debug
		# @enable()

		# Your other initializations here - for example setting triggers, etc.
		return

	constructor: ->

	echo: (text) ->
		text

	uninstall: (automatic) ->
		base = ScriptApp.getService().getUrl()
		if not automatic and base
			# Only if no automatic uninstall (e.g. the user has to confirm) and the script is published as a WebApp
			target = base.substring 0, base.lastIndexOf '/'

			HtmlService.createHtmlOutput	"""Click here to <a href="#{target}/manage/uninstall">uninstall</a>."""
		else
			# Fallback, if this is not a published WebApp or automatic uninstall is wanted
			# remove all triggers, so there are no errors when we invalidate the authentification
			for trigger in ScriptApp.getScriptTriggers()
				ScriptApp.deleteTrigger trigger

			# invalidate authentication
			ScriptApp.invalidateAuth()
			ContentService.createTextOutput 'Application successfully uninstalled.'


	# Uncomment this if your script needs to publish itself as a service.
	# You don't need this if yourself published this script as a service from within the Google Apps Script edtior.
	#
	# @enable: ->
	#	svc = ScriptApp.getService()
	#	unless svc.isEnabled()
	#		svc.enable svc.Restriction.MYSELF
	#		Logger.log "The app is now available under '#{svc.getUrl()}'" if debug
	#	return
	#
	#@disable: ->
	#	ScriptApp.getService().disable()
	#	return

# WebApp-specific events:

doGet = (request) ->
	MyClass.setup()

	m = new MyClass

	switch request.parameter.action
		when 'jsonp'
			JSONPHelper.response null, (hello: 'World!'), request.parameter.callback
		when 'uninstall'
			m.uninstall request.parameter.automatic is 'true'
		when 'count'
			current = (Number UserProperties.getProperty 'count') or 0
			UserProperties.setProperty 'count', ++current
			ContentService.createTextOutput current
		when 'dump'
			JSONPHelper.response null, properties: UserProperties.getProperties()
		else
			url = ScriptApp.getService().getUrl()
			ret = HtmlService.createHtmlOutput()
			ret.append m.echo 'Works.'
			ret.append '<ul>'
			ret.append "<li><a href='#{url}?action=jsonp'>Check out JSON</a></li>"
			ret.append "<li><a href='#{url}?action=jsonp&callback=alert'>Check out JSONP</a></li>"
			ret.append "<li><a href='#{url}?action=bump'>Bump count</a></li>"
			ret.append "<li><a href='#{url}?action=dump'>Get all user properties</a></li>"
			ret.append "<li><a href='#{url}?action=uninstall&automatic=true'>Or uninstall the service</a></li>"
			ret.append '</ul>'
			ret

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