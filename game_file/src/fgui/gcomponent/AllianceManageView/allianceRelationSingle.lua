local allianceRelationCtrl = SoraDGetCtrl("allianceRelationCtrl")
local allianceQuery = SoraDGetCtrl("allianceQuery")
local allianceDesRead = include("allianceDesRead")
local baseComponent = require("fgui.base.baseComponent")
local allianceRelationSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceManageView/allianceRelationSingle", allianceRelationSingle)
function allianceRelationSingle:onInit()
	self.curType = gAllianceRelationType.ALLY
	self.fields.Text_apply:setString(i18n("common_text_1051"))
	self:setApply(false)
	self.fields.Button_ok:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Panel_touch:addClickListener(handler(self, self.btnInfoClickCallBack))
	self:fixChildrenPos()
end
function allianceRelationSingle:onShow()
end
function allianceRelationSingle:initData(data)
	self.tableSingleData = data
	self.curType = self.tableSingleData.type
	_ENV = nil
	;(nil).abbr = self.tableSingleData.aInfo.abbr
	;(nil).name = self.tableSingleData.aInfo.name
	self.fields.Text_name:setString(i18n("common_text_186", nil))
	_ENV = i18n("common_text_186", nil)
	i18n("common_text_186", nil).name = self.tableSingleData.aInfo.leaderName
	self.fields.Text_leader:setString(i18n("common_text_170", i18n("common_text_186", nil)))
	self.fields.Text_member:setString(self.tableSingleData.aInfo.memberCount .. "/" .. self.tableSingleData.aInfo.limitCount)
	self.fields.Text_power:setString(string.formatnumberthousands(self.tableSingleData.aInfo.totalPower))
	self.fields.Text_language:setString(allianceDesRead.getLanguageName(self.tableSingleData.aInfo.language))
	self.fields.flag:clearContent()
	local flagNode = allianceDesRead.getFlagNode(self.tableSingleData.aInfo.flag)
	flagNode:setScale(0.66)
	flagNode:setPosition(50, 50)
	self.fields.flag:setContent(flagNode)
	local btnStr = i18n("common_text_3081")
	local btnColor = 1
	local isRank = allianceDesRead.checkRank(gAllianceRank.R4)
	self:setApply(false)
	if self.curType == 4 then
		if self.tableSingleData.inviteType == "send" then
			btnStr = i18n("common_text_184")
			btnColor = 2
			self:setApply(true)
		elseif self.tableSingleData.inviteType == "recv" then
			btnStr = i18n("common_text_140")
			btnColor = 0
		end
	end
	self.fields.Button_ok:setEnabled(isRank)
	self.fields.Button_ok:setString(btnStr)
	self.fields.Button_ok:setBtnColorIndex(btnColor)
	if worldMapDefine.isInWarForbid(true) then
		self.fields.Button_ok:setBright(false)
	end
end
function allianceRelationSingle:setApply(ret)
	self.fields.Text_apply:setVisible(ret)
	self.fields.applybg:setVisible(ret)
end
function allianceRelationSingle:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
end
function allianceRelationSingle:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "allianceRelationSingle" and not SoraDSearchPanelFromManagerByName("allianceInfoView") then
			SoraDOpenAllianceInfoView(alliance)
		end
	end
end
function allianceRelationSingle:btnClickCallBack()
	SoraDPlaySound()
	if worldMapDefine.isInWarForbid() then
		return
	end
	if allianceDesRead.checkRank(gAllianceRank.R4, true) then
		local aid = self.tableSingleData.aInfo.aid
		if self.curType == gAllianceRelationType.ALLY then
			allianceRelationCtrl:reqDelRelation(aid)
		elseif self.curType == gAllianceRelationType.FRIENDLY then
			allianceRelationCtrl:reqDelRelation(aid)
		elseif self.curType == gAllianceRelationType.ENEMY then
			allianceRelationCtrl:reqDelRelation(aid)
		elseif self.curType == 4 then
			if self.tableSingleData.inviteType == "send" then
				allianceRelationCtrl:reqCancelInviteAllyAlliance(aid)
			elseif self.tableSingleData.inviteType == "recv" then
				allianceRelationCtrl:reqAcceptAllyAllianceInvite(aid)
			end
		end
	end
end
function allianceRelationSingle:btnInfoClickCallBack()
	SoraDPlaySound()
	_ENV = nil
	_ENV, (nil).aid = self.tableSingleData.aInfo.aid, self.tableSingleData.aInfo.aid
	self.tableSingleData.aInfo.aid.from = "allianceRelationSingle"
	allianceQuery:reqAllianceByID(nil, self.tableSingleData.aInfo.aid)
end
return allianceRelationSingle
