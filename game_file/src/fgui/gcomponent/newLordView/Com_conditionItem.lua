local necklaceTechRead = include("necklaceTechRead")
local necklaceTecCtrl = SoraDGetCtrl("necklaceTecCtrl")
local publicRead = include("publicRead")
local publicUtil = include("publicUtil")
local baseComponent = require("fgui.base.baseComponent")
local Com_conditionItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_conditionItem", Com_conditionItem)
function Com_conditionItem:onInit()
	self.fields.Button_jump:setTitle(i18n("common_text_477"))
	self.fields.Button_jump:addClickListener(handler(self, self.onClick_Button_jump))
	self:fixChildrenPos()
end
function Com_conditionItem:onShow()
end
function Com_conditionItem:initData(data)
	self.data = data
	if self.data.type == "tech" then
		local cfg = necklaceTechRead.getTechCfg(self.data.id)
		self.fields.icon:setURL(cfg.techIcon)
		necklaceTechRead = nil
		;(nil).science = i18n(cfg.techName)
		;(nil).lv = self.data.lv
		self.fields.title:setString(i18n("common_text_336", nil))
		local tData = necklaceTecCtrl:getTechnoDataByID(self.data.id)
		local isResearch = tData.currentLevel >= self.data.lv or false
		self.fields.title:setColor(isResearch and "#F0E6D2" or "#E02B2B")
		self.fields.nYes:setVisible(isResearch)
		self.fields.nNo:setVisible(not isResearch)
		self.fields.Button_jump:setTitle(i18n("common_text_062"))
		self.fields.Button_jump:setVisible(not isResearch)
	else
		self.fields.icon:setURL(publicRead.getIcon(self.data.id))
		necklaceTechRead = publicRead.getIcon(self.data.id)
		publicRead.getIcon(self.data.id).val = string.formatnumberthousands(publicUtil.getCount(self.data.id))
		publicRead.getIcon(self.data.id).need = string.formatnumberthousands(self.data.count)
		self.fields.title:setString(i18n("%{val}/%{need}", publicRead.getIcon(self.data.id)))
		local isEnough = publicUtil.getCount(self.data.id) >= self.data.count
		self.fields.title:setColor(isEnough and "#F0E6D2" or "#E02B2B")
		self.fields.nYes:setVisible(isEnough)
		self.fields.nNo:setVisible(not isEnough)
		self.fields.Button_jump:setTitle(i18n("common_text_477"))
		self.fields.Button_jump:setVisible(not isEnough)
	end
end
function Com_conditionItem:onClick_Button_jump(context)
	SoraDPlaySound()
	if self.data.type == "tech" then
		_ENV = nil
		;(nil).techID = self.data.id
		uiManager:show("neckTechDetail", nil)
	elseif self.data.type == "item" then
		_ENV = nil
		;(nil).itemID = self.data.id
		uiManager:show("CommonSourceGuide", nil)
	elseif self.data.type == "resource" then
		_ENV = nil
		;(nil).rid = self.data.id
		uiManager:show("resourceBuyView", nil)
	end
end
return Com_conditionItem
