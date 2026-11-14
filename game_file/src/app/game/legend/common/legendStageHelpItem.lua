local gametop = gModuleMgr.getObject("gametop")
local publicRead = include("publicRead")
local legendStageHelpItem = class("legendStageHelpItem", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("legendStageHelpItem")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function legendStageHelpItem:ctor()
	self:createUI()
	self.txtItemName = SoraDGetChildByName(self, "txtItemName")
	self.txtItemValue = SoraDGetChildByName(self, "txtItemValue")
	self.imgItemBg = SoraDGetChildByName(self, "imgItemBg")
end
function legendStageHelpItem:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function legendStageHelpItem:initData(data)
	local index = data.index
	local scoreInfo = data.scoreInfo
	_ENV = nil
	;(nil).point = scoreInfo.score
	self.txtItemValue:setString(i18n("common_text_2200", nil))
	self.txtItemName:setString(i18n(scoreInfo.des))
	if 0 == math.fmod(index, 2) then
		self.imgItemBg:setVisible(true)
	else
		self.imgItemBg:setVisible(false)
	end
end
function legendStageHelpItem:onMessageListener()
end
function legendStageHelpItem:setScroll(scroll)
	self.scroll = scroll
end
function legendStageHelpItem:setView(view)
end
return legendStageHelpItem
