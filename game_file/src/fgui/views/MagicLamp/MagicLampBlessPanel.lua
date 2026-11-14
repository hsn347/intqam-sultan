local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampBlessPanel = class("MagicLampBlessPanel", baseFguiPanel)
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local magicLampRead = include("magicLampRead")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
_ENV = "backpackCtrl"
;("backpackCtrl")[1] = "zndzf_bj.usm"
local ("backpackCtrl")[2], usmEffectPaths = "SD_shendengzf.usm", "backpackCtrl"
function MagicLampBlessPanel:ctor(...)
	self.isHideCurrentSceneView = true
	self.super.ctor(self, ...)
	print("MagicLampBlessPanel:ctor", self.viewName)
end
function MagicLampBlessPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "MagicLampSkill"
	end
	return self._packageList
end
function MagicLampBlessPanel:onInit()
	if not SoraDFIsRA() then
		self.fields.Com_ML_BlessDetials:fixPos()
	end
	self.inited = false
	self.curType = self.param.jinnType
	print("=======MagicLampBlessPanel:onInit")
	self.fields.Com_title:initData(i18n("magic_lamp_title_08"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.btn_recount:setTitle(i18n("magic_lamp_title_09"))
	self.fields.btn_recount:addClickEventListener(handler(self, self.onRecountClick))
	self.fields.Com_ML_BlessDetials:setVisible(false)
	self.fields.Com_ML_BlessDetials:setHideCallback(handler(self, self.hideDetails))
	self.fields.mask:setVisible(false)
	self.fields.mask:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.hideDetailsClick))
	self.scrollTo = self.param.scrollTo
	self.fields.Usm_1:setEffectPath(usmEffectPaths[self.curType], true)
end
function MagicLampBlessPanel:endShow()
	if self.Com_BlessList == nil then
		self.fields.Com_ML_BlessList:setURL("ui://MagicLamp/Com_ML_BlessList_" .. self.curType)
		self.Com_BlessList = self.fields.Com_ML_BlessList:getComponent()
		self.Com_BlessList:setHeight(self.fields.Com_ML_BlessList:getSize().height)
		self.Com_BlessList:setCustomData("lamp" .. self.curType)
		self.Com_BlessList:setBlessClick(handler(self, self.onBlessClick))
	end
	print("=======MagicLampBlessPanel:onShow")
	self:updateView()
	self.inited = true
	if self.curType == 2 then
		self.view:setChildIndex(self.fields.Com_ML_BlessList, 2)
		self.fields.Com_ML_BlessList:setSize(cc.size(640, self.view:getSize().height))
	end
end
function MagicLampBlessPanel:updateView()
	self.jinnData = magicLampCtrl:getJinnByType(self.curType)
	self.breakCfg = magicLampRead.getBreakThroughCfg(self.curType, self.jinnData.starLv)
	self.blessNum = self.jinnData.blessPoint
	self.fields.text_blessNum:setString(i18n("magic_lamp_text_099") .. self.blessNum)
	local blessCfgs = magicLampRead.getBlessCfgs(self.curType)
	self.blessCfgList, magicLampCtrl = self.curType, self.curType
	for k, v in pairs(blessCfgs) do
		local bless = self.jinnData.blessList[tostring(k)]
		local magicLampCtrl, blessLv = k, bless == nil and 0 or bless.lv
		k.BlessID = k
		k.lv = blessLv
		k.cfg = v[blessLv == 0 and 1 or blessLv]
		k.nextCfg = v[blessLv == 0 and 1 or blessLv + 1]
		local k.lv1Cfg, blessData = v[1], k
		table.insert(self.blessCfgList, blessData)
	end
	table.sort(self.blessCfgList, function(a, b)
		return a.BlessID < b.BlessID
	end)
	if not self.inited then
		self.Com_BlessList:setAlpha(0)
		self.Com_BlessList:runAction(ffa.seq(ffa.delay(0.2), ffa.fadeIn(0.3)))
		self.fields.Usm_1:setAlpha(0)
		self.fields.Usm_1:runAction(ffa.fadeIn(0.3))
	end
	if self.curType ~= 1 then
		self.Com_BlessList:createItems(self.blessCfgList, self.breakCfg.MaxLv, self.curType)
	end
	self.Com_BlessList:initData(self.blessCfgList, self.breakCfg.MaxLv, not self.inited, self.scrollTo)
	self.scrollTo = nil
end
function MagicLampBlessPanel:onRecountClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).jinnType = self.curType
	uiManager:show("MagicLampRecount", nil)
end
function MagicLampBlessPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("magic_lamp_text_031")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function MagicLampBlessPanel:onBlessClick(data, pos, selectedObj)
	SoraDPlaySound()
	if data.cfg.PointType == 2 and data.lv ~= 0 then
		_ENV = nil
		;(nil).jinnType = self.curType
		;(nil).blessID = data.BlessID
		uiManager:show("MagicLampPower", nil)
		return
	end
	self.selectedObj = selectedObj
	self.selectedObj:setActiveAni(0, 1.0)
	pos.x = pos.x / self:getScale()
	pos.y = pos.y / self:getScale()
	pos.y = pos.y + 50
	self.fields.Com_ML_BlessDetials:initData(data, self.curType)
	local height = 0
	local parent = self
	height = parent:getSize().height
	local containerSize = self.view:getSize()
	local size = self.fields.Com_ML_BlessDetials:getSize()
	if SoraDFIsRA() then
		pos.x = pos.x + size.width / 2
		if 0 > pos.x - size.width then
			pos.x = size.width
		elseif pos.x > containerSize.width then
			pos.x = containerSize.width
		end
	else
		pos.x = pos.x - size.width / 2
		if 0 > pos.x then
			pos.x = 0
		elseif pos.x + size.width > containerSize.width then
			pos.x = containerSize.width - size.width
		end
	end
	if pos.y + size.height > containerSize.height then
		pos.y = containerSize.height - size.height
	end
	self.fields.Com_ML_BlessDetials:setPosition(pos)
	self.fields.Com_ML_BlessDetials:setVisible(true)
	self.fields.mask:setVisible(true)
end
function MagicLampBlessPanel:hideDetailsClick()
	SoraDPlaySound()
	self:hideDetails()
end
function MagicLampBlessPanel:hideDetails()
	self.fields.Com_ML_BlessDetials:setVisible(false)
	self.fields.mask:setVisible(false)
	if self.selectedObj then
		self.selectedObj:initData(self.selectedObj.data)
		self.selectedObj = nil
	end
end
function MagicLampBlessPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "bless" then
		return self.Com_BlessList:gameGuide_getTarget(itemName, parameters)
	end
	return self.fields[itemName]
end
return MagicLampBlessPanel
