local baseProxy = class("baseProxy")
function baseProxy:ctor(viewName)
	self.viewName = viewName
	self.listView, _ENV, self.proxyName = nil, nil, viewName
	self.uiState = UI_STATE.Close
	self.messages, _ENV, self.addMode = UI_ADD_MODE.Cover, UI_ADD_MODE.Cover, UI_ADD_MODE.Cover
	self.panelConfig = uiManager:getPanelData(viewName)
	if self.panelConfig.addMode then
		self.addMode = self.panelConfig.addMode
	end
	self.freeImagesOnExit = true
	self.arrayImagesPath = nil
end
function baseProxy:getState()
	return self.uiState
end
function baseProxy:getPanel()
	return self.view
end
function baseProxy:registerView(view)
	table.insert(self.listView, view)
	self.view = view
	if view.isInstance then
		view:registerProxy()
	end
	SoraDRemoveMessageByTarget(self)
	self:onRegisterEvent()
	self:onRegisterView()
	uiManager:pushView(view)
	if self.panelConfig.isStack then
		SoraDAddPanelToManager(view, true)
	end
	view:endShow()
end
function baseProxy:showPanel(param)
