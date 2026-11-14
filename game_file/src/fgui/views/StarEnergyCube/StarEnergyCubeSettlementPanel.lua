local publicRead = include("publicRead")
local starCubeCtrl = SoraDGetCtrl("starCubeCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local StarEnergyCubeSettlementPanel = class("StarEnergyCubeSettlementPanel", baseFguiPanel)
function StarEnergyCubeSettlementPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("StarEnergyCubeSettlementPanel:ctor", self.viewName)
end
function StarEnergyCubeSettlementPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function StarEnergyCubeSettlementPanel:onInit()
	print("=======StarEnergyCubeSettlementPanel:onInit")
	self.view:setScale(0)
	self.controllers.c1:setSelectedIndex(2)
	self.fields.Effect_lose:setIsLoop(false)
	self.fields.Spine_sucess:setEffectPath("spine/shengli.skel")
	self.fields.Spine_sucess.effect:setAnimation(0, "animation", true)
	self.fields.Button_report:setTitleText(i18n("Anchor_text_14"))
	self.fields.Button_confirm:setTitleText(i18n("common_text_204"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_report:addClickListener(handler(self, self.onClickReport))
	self.fields.Button_confirm:addClickListener(handler(self, self.onClickClose))
end
function StarEnergyCubeSettlementPanel:initData(data)
	self.reward = data.reward
	if data.isWin and data.keyID then
		self.controllers.c3:setSelectedIndex(1)
		self.fields.Icon_key:setURL(publicRead.getIcon(self.reward[1].id))
		self.fields.title:setString(i18n("Martial_arts_text_27"))
	elseif data.isWin then
		self.fields.title:setString(i18n("Martial_arts_text_29"))
	else
		self.fields.title:setString(i18n("Martial_arts_text_30"))
	end
	if self.reward and next(self.reward) then
		self.fields.List_reward:setNumItems(table.nums(self.reward))
	end
	_UPVALUE2_ = self.fields.List_reward
	self.fields.List_reward[1] = ffa.fadeIn(0.1)
	self.fields.List_reward[2] = ffa.scaleTo(0.1, 1, 1)
	self.fields.List_reward[3] = ffa.callFunc(function()
		if data.isWin then
		else
			self.fields.Effect_lose:playOnce()
		end
	end)
	self.fields.List_reward[4] = ffa.callFunc(function()
		if data.isWin then
		else
			self.fields.Effect_lose:playOnce()
		end
	end)
	self.fields.List_reward[5] = ffa.callFunc(function()
		if data.isWin then
		else
			self.fields.Effect_lose:playOnce()
		end
	end)
	local spawn = ffa.spawn(self.fields.List_reward)
	self.view:runAction(spawn)
end
function StarEnergyCubeSettlementPanel:setFailDisplay(args)
	self.controllers.c1:setSelectedIndex(0)
	self.controllers.c2:setSelectedIndex(0)
end
function StarEnergyCubeSettlementPanel:setSuccessDisplay()
	self.controllers.c1:setSelectedIndex(1)
	self.controllers.c2:setSelectedIndex(SoraDGetDefaultLanguage() == "ar" and 1 or 2)
end
function StarEnergyCubeSettlementPanel:onItemRenderer(index, object)
	object:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function StarEnergyCubeSettlementPanel:onClickReport()
	SoraDPlaySound()
	local arenaltCtrl = include("arenaltCtrl")
	local reportData = starCubeCtrl:getBattleReportData()
	local outData = arenaltCtrl.reportReMake(reportData, gArenaBattleType.STAR_ENERGY_CUBE)
	local panel = SoraDCreatePanel("mailItemDetailView")
	panel:show()
	panel:hideRightAndLeftBtn()
	panel:initWithData(outData, "key")
	self:close()
end
function StarEnergyCubeSettlementPanel:onClickClose()
	SoraDPlaySound()
	self:close()
end
function StarEnergyCubeSettlementPanel:onShow()
	print("=======StarEnergyCubeSettlementPanel:onShow")
	self:initData(self.proxy.param)
	if self.proxy.param.isWin then
		self:setSuccessDisplay()
	else
		self:setFailDisplay()
	end
end
function StarEnergyCubeSettlementPanel:onHide()
	_ENV = nil
	;(nil).msg = "MESSAGE_STAR_ENERGY_CUBE"
	;(nil).subMsg = "refreshTarget"
	SoraDSendMessage(nil)
end
return StarEnergyCubeSettlementPanel
