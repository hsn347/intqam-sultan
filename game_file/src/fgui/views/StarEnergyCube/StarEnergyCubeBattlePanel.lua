local publicRead = include("publicRead")
local starCubeCtrl = SoraDGetCtrl("starCubeCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local StarEnergyCubeBattlePanel = class("StarEnergyCubeBattlePanel", baseFguiPanel)
function StarEnergyCubeBattlePanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("StarEnergyCubeBattlePanel:ctor", self.viewName)
end
function StarEnergyCubeBattlePanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ForeignPavilion"
	end
	return self._packageList
end
function StarEnergyCubeBattlePanel:onInit()
	print("=======StarEnergyCubeBattlePanel:onInit")
	self.fields.Button_report:setTitleText(i18n("Anchor_text_14"))
	self.fields.Button_confirm:setTitleText(i18n("common_text_204"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_report:addClickListener(handler(self, self.onClickReport))
	self.fields.Button_confirm:addClickListener(handler(self, self.onClickClose))
end
function StarEnergyCubeBattlePanel:onItemRenderer(index, object)
	object:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function StarEnergyCubeBattlePanel:onClickReport()
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
function StarEnergyCubeBattlePanel:onClickClose()
	SoraDPlaySound()
	self:close()
end
function StarEnergyCubeBattlePanel:onShow()
	local data = self.proxy.param
	if data.isWin then
		SoraDPlaySound("elimiateGame", 5)
		if display.height > 1136 then
			self.fields.Usm_1:setScale(display.height / 1136)
			self.fields.Usm_2:setScale(display.height / 1136)
			self.fields.Usm_3:setScale(display.height / 1136)
		end
		self.fields.Usm_1:setEffectPath("dunpai2.usm", false)
		self.fields.Usm_2:setEffectPath(SoraDFIsRA() and "dunpai5.usm" or "dunpai4.usm", false)
		self.fields.Usm_2:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		self.fields.Usm_3:setEffectPath("G_dunpai1.usm,G_xh_dunpai3.usm")
		self.fields.Usm_3:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	else
		SoraDPlaySound("huntSound", "hunt_lost")
		self.fields.Usm_1:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		self.fields.Usm_1:setEffectPath("sp_sszzsb_001.usm", false)
		self.fields.lose_sp:setURL(SoraDFIsRA() and "FONT_shibai_ar.png" or "FONT_shibai.png")
	end
	self.reward = data.reward
	if data.isWin and data.keyID then
		self.fields.title:setString(i18n("Martial_arts_text_27"))
	elseif data.isWin then
		self.fields.title:setString(i18n("Martial_arts_text_29"))
	else
		self.fields.title:setString(i18n("Martial_arts_text_30"))
	end
	if self.reward and next(self.reward) then
		self.fields.List_reward:setNumItems(table.nums(self.reward))
	end
end
function StarEnergyCubeBattlePanel:onHide()
	_ENV = nil
	;(nil).msg = "MESSAGE_STAR_ENERGY_CUBE"
	;(nil).subMsg = "refreshTarget"
	SoraDSendMessage(nil)
end
return StarEnergyCubeBattlePanel
