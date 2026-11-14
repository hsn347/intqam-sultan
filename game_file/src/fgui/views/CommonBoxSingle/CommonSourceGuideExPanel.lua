local jumpDesRead = include("jumpDesRead")
local publicRead = include("publicRead")
local itemDesRead = include("itemDesRead")
local CommonSourceGuidePanel = require("fgui.views.CommonBoxSingle.CommonSourceGuidePanel")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommonSourceGuideExPanel = class("CommonSourceGuideExPanel", CommonSourceGuidePanel)
function CommonSourceGuideExPanel:ctor(...)
	CommonSourceGuideExPanel.super.ctor(self, ...)
	print("CommonSourceGuideExPanel:ctor", self.viewName)
	self.debug = true
end
function CommonSourceGuideExPanel:onInit()
	print("=======CommonSourceGuideExPanel:onInit")
	self.super.onInit(self)
end
function CommonSourceGuideExPanel:onShow()
	print("=======CommonSourceGuideExPanel:onShow")
	self.itemIdList, _ENV, self.sourcesMap, _ENV = print, print, print, print
	local itemID = self.param.itemID
	if itemID then
		self.itemIdList[1] = itemID
	else
		self.itemIdList = self.param.itemList
	end
	local idx = 1
	local _ENV, sources
	for _, id in ipairs(self.itemIdList) do
		local sourceDatas = itemDesRead.getOutput(id)
		if not self.sourcesMap[id] then
			_ENV = nil
			;(nil).idx = idx
			self.sourcesMap[id], (nil).length = nil, #sourceDatas
		end
		for _, v in ipairs(sourceDatas) do
			table.insert(sources, v)
		end
		idx = idx + #sourceDatas
	end
	self:init(sources, self.param.desStr)
	if self.param.tip then
		self.fields.Text_tip:setString(self.param.tip)
	end
end
function CommonSourceGuideExPanel:onItemRenderer(index, obj)
	local _fields = fguiHelper.get_fields(obj)
	local _ctrls = fguiHelper.get_controllers(obj)
	local com_sourceGUide = _fields.Com_sourceGuide
	self.super.onItemRenderer(self, index, com_sourceGUide)
	local firstItemID
	local length = 0
	for k, v in pairs(self.sourcesMap) do
		if v.idx == index + 1 then
			firstItemID = k
			length = v.length
			break
		end
	end
	_ctrls.c1:setSelectedIndex(firstItemID == nil and 1 or 0)
	if firstItemID then
		_fields.title:setString(publicRead.getName(firstItemID))
		_fields.bg:setHeight(154 + 109 * (length - 1))
	end
end
return CommonSourceGuideExPanel
