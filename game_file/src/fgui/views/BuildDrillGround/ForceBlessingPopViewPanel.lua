local arenaCtrl = SoraDGetCtrl("arenaCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local arenaltCtrl = include("arenaltCtrl")
local buffDesRead = include("buffDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ForceBlessingPopViewPanel = class("ForceBlessingPopViewPanel", baseFguiPanel)
local refreshMaxTimes = 9999
function ForceBlessingPopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ForceBlessingPopViewPanel:ctor", self.viewName)
end
function ForceBlessingPopViewPanel:onInit()
	print("=======ForceBlessingPopViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("circus_text_18"))
	self.fields.txtForce:setString(i18n("circus_text_22"))
	self.fields.txtIns:setString(i18n("circus_text_24"))
	self.fields.btnRefresh:addClickListener(handler(self, self.buttonRefreshClick))
	_UPVALUE2_ = self.fields.btnRefresh.addClickListener
	self.tableBless, self.fields.btnRefresh.addClickListener[1] = self.fields.btnRefresh.addClickListener, self.fields.txtBlessing_1
	self.tableBless, self.fields.btnRefresh.addClickListener[2] = self.fields.btnRefresh.addClickListener, self.fields.txtBlessing_2
	if not SoraDFIsRA() then
		self.view:fixChildrenPos()
	end
end
function ForceBlessingPopViewPanel:onShow()
	print("=======ForceBlessingPopViewPanel:onShow")
	self:initData(self.param.battleType)
end
function ForceBlessingPopViewPanel:initData(bType)
	if not bType then
		return
	end
	self.bType = bType
	self.battleInfo = arenaCtrl:getBattleInfo(self.bType)
	local remainTimes = refreshMaxTimes - self.battleInfo.refreshBuffTimes
	local buffTable = arenaltCtrl.getCostGoldByTypeAndTimes(self.bType, self.battleInfo.refreshBuffTimes + 1)
	local lordBaseInfo = lordInfoCtrl:getBaseInfo()
	if buffTable.Gold <= 0 then
		self.fields.btnRefresh:setFreeTitle(i18n("circus_text_23"), 1)
	else
		self.fields.btnRefresh:setString(i18n("common_text_911"))
		self.fields.btnRefresh:setCostNum(buffTable.Gold, lordBaseInfo.gold)
	end
	if remainTimes <= 0 then
		self.fields.btnRefresh:setEnabled(false)
		self.fields.btnRefresh:setFreeTitle("MAX", 1)
	end
	for i, v in ipairs(self.tableBless) do
		v:setVisible(false)
	end
	for i, v in ipairs(self.battleInfo.personalBuff) do
		local buffInfo = arenaltCtrl.getArmyBuff(v.effectType)
		if buffInfo then
			arenaCtrl = i18n("common_text_911")
			i18n("common_text_911").title = i18n(buffInfo.effectName)
			arenaCtrl, arenaCtrl, i18n("common_text_911").value = buffInfo.effectName, v.value / 10, v.value / 10
			;(v.value / 10).title, buffInfo.effectName.color = buffInfo.effectName, "#D7C39B"
			self.tableBless[i]:setString(i18n_html("common_text_1298", i18n("common_text_911")))
			self.tableBless[i]:setVisible(true)
		end
	end
	local restraintList = arenaltCtrl.getRestraintList(self.bType)
	arenaCtrl = 1
	arenaCtrl, arenaCtrl, (1).num = "%", restraintList[1].Buffdigit / 10 .. "%", restraintList[1].Buffdigit / 10 .. "%"
	;(restraintList[1].Buffdigit / 10 .. "%").num, ("%").color = "%", "#FFD43E"
	local str1 = i18n_html(restraintList[1].effectName, 1, restraintList[1].Buffdigit / 10 .. "%")
	arenaCtrl = restraintList[1].Buffdigit / 10 .. "%"
	arenaCtrl, arenaCtrl, (restraintList[1].Buffdigit / 10 .. "%").num = "%", restraintList[2].Buffdigit / 10 .. "%", restraintList[2].Buffdigit / 10 .. "%"
	;(restraintList[2].Buffdigit / 10 .. "%").num, ("%").color = "%", "#FFD43E"
	local str2 = i18n_html(restraintList[2].effectName, restraintList[1].Buffdigit / 10 .. "%", restraintList[2].Buffdigit / 10 .. "%")
	arenaCtrl = restraintList[2].Buffdigit / 10 .. "%"
	arenaCtrl, arenaCtrl, (restraintList[2].Buffdigit / 10 .. "%").num = "%", restraintList[3].Buffdigit / 10 .. "%", restraintList[3].Buffdigit / 10 .. "%"
	;(restraintList[3].Buffdigit / 10 .. "%").num, ("%").color = "%", "#FFD43E"
	local str3 = i18n_html(restraintList[3].effectName, restraintList[2].Buffdigit / 10 .. "%", restraintList[3].Buffdigit / 10 .. "%")
	self.fields.txtInfantry:setString(str1)
	self.fields.txtCavalry:setString(str2)
	self.fields.txtArcher:setString(str3)
end
function ForceBlessingPopViewPanel:buttonRefreshClick()
	SoraDPlaySound()
	local lordBaseInfo = lordInfoCtrl:getBaseInfo()
	local buffTable = arenaltCtrl.getCostGoldByTypeAndTimes(self.bType, self.battleInfo.refreshBuffTimes + 1)
	if lordBaseInfo.gold < buffTable.Gold then
		SoraDShowMsgBox(i18n("common_text_423"), i18n("common_text_424"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				if GLOBAL_GAME_RECHARGE_MODE then
					uiManager:show("rechargeView")
				else
					SoraDCreatePanel("rechargeView"):show()
				end
			end
		end)
		return
	end
	arenaCtrl:reqRefreshBuff(self.bType)
	SoraDShowLoading(self:displayObject())
end
function ForceBlessingPopViewPanel:onMsgRefreshBuff(...)
	SoraDCloseLoading(self:displayObject())
	self:initData(self.bType)
end
return ForceBlessingPopViewPanel
