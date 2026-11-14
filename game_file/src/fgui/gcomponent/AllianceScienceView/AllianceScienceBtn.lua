local gametop = gModuleMgr.getObject("gametop")
local allianceScience = gametop.playertop_:getModule("allianceScience")
local baseComponent = require("fgui.base.baseComponent")
local AllianceScienceBtn = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceScienceView/AllianceScienceBtn", AllianceScienceBtn)
function AllianceScienceBtn:onInit()
	self.fields.Button_donate:fixChildrenPos()
	self.fields.Label_point:fixChildrenPos()
	self.fields.Label_honor:fixChildrenPos()
	self.fields.Label_score:fixChildrenPos()
	_ENV, _ENV = self.fields.Label_score, self.fields.Label_score.fixChildrenPos
	self.fields.Label_score.key = gAScienceLv.JUNIOR_USE
	_ENV, self.fields.Label_score.fixChildrenPos.res, self.fields.Label_score.data = self.fields.Label_score, self.fields.Label_score, 0
	self.fields.Label_score.key = gAScienceLv.JUNIOR_HONOR
	_ENV, self.fields.Label_score.fixChildrenPos.honor, self.fields.Label_score.data = self.fields.Label_score, self.fields.Label_score, 0
	self.fields.Label_score.key = gAScienceLv.JUNIOR_HONOR
	_ENV, self.fields.Label_score.fixChildrenPos.score, self.fields.Label_score.data = self.fields.Label_score, self.fields.Label_score, 0
	self.fields.Label_score.key = gAScienceLv.JUNIOR_SCI_POINT
	self.fields.Label_score.fixChildrenPos.spoint, self.fields.Label_score.data = self.fields.Label_score, 0
	self.tableBtnData, _ENV, self.tableDonateData, self.fields.Label_score.fixChildrenPos.type = self.fields.Label_score.fixChildrenPos, self.fields.Label_score.fixChildrenPos, self.fields.Label_score.fixChildrenPos, gAScienceDonateType.Junior
	self.handle = nil
	self.resEnough = false
	self.rid = nil
	self.fields.Button_donate:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Button_donate:setString("???")
	self.labelNeed = self.fields.Button_donate:getChild("Text_gold")
	self:btnStateChange(false)
end
function AllianceScienceBtn:onShow()
end
function AllianceScienceBtn:registerEvent()
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.resUpdate))
end
function AllianceScienceBtn:setHandle(handle)
	self.handle = handle
end
function AllianceScienceBtn:setDonateType(type)
	self.tableDonateData.type = type
end
function AllianceScienceBtn:initData(btnData)
	self.tableBtnData = btnData
	self:updateView()
end
function AllianceScienceBtn:updateView()
	local allianceltCtrl = include("allianceltCtrl")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	if self.tableDonateData.type == gAScienceDonateType.Junior then
		self.tableDonateData.res.key = gAScienceLv.JUNIOR_USE
		self.tableDonateData.honor.key = gAScienceLv.JUNIOR_HONOR
		self.tableDonateData.score.key = gAScienceLv.JUNIOR_HONOR
		self.tableDonateData.spoint.key = gAScienceLv.JUNIOR_SCI_POINT
	elseif self.tableDonateData.type == gAScienceDonateType.Middle then
		self.tableDonateData.res.key = gAScienceLv.MIDDLE_USE
		self.tableDonateData.honor.key = gAScienceLv.MIDDLE_HONOR
		self.tableDonateData.score.key = gAScienceLv.MIDDLE_HONOR
		self.tableDonateData.spoint.key = gAScienceLv.MIDDLE_SCI_POINT
	elseif self.tableDonateData.type == gAScienceDonateType.Senior then
		self.tableDonateData.res.key = gAScienceLv.SENIOR_USE
		self.tableDonateData.honor.key = gAScienceLv.SENIOR_HONOR
		self.tableDonateData.score.key = gAScienceLv.SENIOR_HONOR
		self.tableDonateData.spoint.key = gAScienceLv.SENIOR_SCI_POINT
	end
	self.rid = nil
	local member = memberMgr:getOwnMember()
	self.rid = member:getDonateData(self.tableBtnData.id, self.tableBtnData.lv, self.tableDonateData.type)
	dump(self.tableBtnData, "tableBtnData")
	print("self.rid", self.rid)
	self.tableDonateData.res.data = allianceltCtrl.scienceLvInfo(self.tableBtnData.id, self.tableBtnData.lv, self.tableDonateData.res.key)
	self.tableDonateData.honor.data = allianceltCtrl.scienceLvInfo(self.tableBtnData.id, self.tableBtnData.lv, self.tableDonateData.honor.key)
	self.tableDonateData.score.data = allianceltCtrl.scienceLvInfo(self.tableBtnData.id, self.tableBtnData.lv, self.tableDonateData.score.key)
	self.tableDonateData.spoint.data = allianceltCtrl.scienceLvInfo(self.tableBtnData.id, self.tableBtnData.lv, self.tableDonateData.spoint.key)
	self.labelNeed:setColor(display.COLOR_WHITE)
	self.resEnough = false
	if self.rid then
		local resDesRead = include("resDesRead")
		self.tableDonateData.res.data = allianceltCtrl.getDonateCost(self.tableBtnData.id, self.tableBtnData.lv, self.tableDonateData.type, self.rid)
		self.fields.Button_donate:setIcon(resDesRead.getMIcon(self.rid))
		self:resUpdate()
	end
	self.labelNeed:setString(string.formatnumberthousands(self.tableDonateData.res.data))
	self.fields.Label_point:setString(string.formatnumberthousands(self.tableDonateData.spoint.data))
	self.fields.Label_honor:setString(string.formatnumberthousands(self.tableDonateData.honor.data))
	self.fields.Label_score:setString(string.formatnumberthousands(self.tableDonateData.score.data))
	self:btnStateChange(self.rid ~= nil)
	self:updateAdd()
end
function AllianceScienceBtn:updateAdd()
	local honorAdd = allianceScience:getDonateHonorAdd()
	local scoreAdd = allianceScience:getDonateScoreAdd()
	if 0 < honorAdd then
		self.fields.Label_honor:getController("c2"):setSelectedIndex(1)
		allianceScience = nil
		;(nil).value = string.formatnumberthousands(self.tableDonateData.honor.data * honorAdd)
		self.fields.Label_honor:getChild("Text_add"):setString(i18n("common_text_1952", nil))
	else
		self.fields.Label_honor:getController("c2"):setSelectedIndex(0)
	end
	if 0 < scoreAdd then
		self.fields.Label_score:getController("c2"):setSelectedIndex(1)
		allianceScience = i18n("common_text_1952", nil)
		i18n("common_text_1952", nil).value = string.formatnumberthousands(self.tableDonateData.score.data * scoreAdd)
		self.fields.Label_score:getChild("Text_add"):setString(i18n("common_text_1952", i18n("common_text_1952", nil)))
	else
		self.fields.Label_score:getController("c2"):setSelectedIndex(0)
	end
end
function AllianceScienceBtn:resUpdate()
	if self.rid then
		if SoraDEnoughRes(self.rid, self.tableDonateData.res.data) then
			self.resEnough = true
			self.labelNeed:setColor(display.COLOR_WHITE)
		else
			self.labelNeed:setColor(display.COLOR_RED)
		end
	end
end
function AllianceScienceBtn:btnStateChange(isCanTouch, showIcon)
	print("btnStateChange", isCanTouch, showIcon)
	self.fields.Button_donate:setEnabled(isCanTouch)
	if not showIcon then
		self.fields.Button_donate:getController("c1"):setSelectedIndex(isCanTouch and 1 or 0)
	end
end
function AllianceScienceBtn:btnClickCallBack()
	SoraDPlaySound()
	if include("pyramidWarltCtrl").checkPwXianXiaSai() then
		if self.resEnough then
			if self.handle then
				self.handle(self.tableBtnData.id, self.tableDonateData.type)
			end
		elseif self.rid == gIDDef.GOLD then
			SoraDEnoughGold(self.tableDonateData.res.data)
		else
			_ENV = nil
			;(nil).rid = self.rid
			uiManager:show("resourceBuyView", nil)
		end
	end
end
return AllianceScienceBtn
