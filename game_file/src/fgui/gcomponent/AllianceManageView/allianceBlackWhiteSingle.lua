local allianceBWList = SoraDGetCtrl("allianceBWList")
local memberMgr = SoraDGetCtrl("memberMgr")
local allianceQuery = SoraDGetCtrl("allianceQuery")
local allianceDesRead = include("allianceDesRead")
local baseComponent = require("fgui.base.baseComponent")
local allianceBlackWhiteSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceManageView/allianceBlackWhiteSingle", allianceBlackWhiteSingle)
function allianceBlackWhiteSingle:onInit()
	self.singleData, _ENV, self.listType = gAllianceBWListType.BLACK, gAllianceBWListType.BLACK, gAllianceBWListType.BLACK
	self.fields.Button_delete:setString(i18n("common_text_697"))
	self.fields.Button_delete:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Btn_touch:addClickListener(handler(self, self.btnClickAllianceCallBack))
	local member = memberMgr:getOwnMember()
	local rank = member:getProperty("rank")
	self.fields.Button_delete:setVisible(rank >= gAllianceRank.R4)
	self:fixChildrenPos()
end
function allianceBlackWhiteSingle:onShow()
end
function allianceBlackWhiteSingle:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
end
function allianceBlackWhiteSingle:sMsgReqInfoBack(target, data)
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "allianceBlackWhiteSingle" and not SoraDSearchPanelFromManagerByName("allianceInfoView") then
			SoraDOpenAllianceInfoView(alliance)
		end
	end
end
function allianceBlackWhiteSingle:initData(data, listType)
	self.listType = listType
	self.singleData = data
	local flagNode = allianceDesRead.getFlagNode(self.singleData.flag)
	flagNode:setScale(0.6)
	flagNode:setPosition(5, 5)
	self.fields.Node_flag:clearContent()
	self.fields.Node_flag:setContent(flagNode)
	allianceDesRead = nil
	;(nil).abbr = self.singleData.abbr
	;(nil).name = self.singleData.name
	self.fields.Text_name:setString(i18n("common_text_186", nil))
end
function allianceBlackWhiteSingle:btnClickCallBack()
	SoraDPlaySound()
	local notice = self.listType == gAllianceBWListType.BLACK and i18n("common_text_1679") or i18n("common_text_1680")
	_ENV = nil
	;(nil).alliance = self.singleData.name
	;(nil).list = notice
	SoraDShowMsgBox(i18n("common_text_1683", nil), i18n("common_text_054"), nil, function(backType)
		if backType == MSGBOX_CALLBACK_YES then
			allianceBWList:delAllianceBWList(self.singleData.aid, self.listType)
		end
	end)
end
function allianceBlackWhiteSingle:btnClickAllianceCallBack()
	SoraDPlaySound()
	_ENV = nil
	_ENV, (nil).aid = self.singleData.aid, self.singleData.aid
	self.singleData.aid.from = "allianceBlackWhiteSingle"
	allianceQuery:reqAllianceByID(nil, self.singleData.aid)
end
return allianceBlackWhiteSingle
