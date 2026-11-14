local chatFunctions = include("chatFunctions")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001687_RedPacketPanel = class("Activity_9001687_RedPacketPanel", baseFguiPanel)
local gametop = gModuleMgr.getObject("gametop")
local redenvelopesCtrl = gametop.playertop_:getModule("redenvelopesCtrl")
local chatRedPacketMgr = gChatMgrs:getMgr("chatRedPacketMgr")
function Activity_9001687_RedPacketPanel:ctor(...)
	self.isLRU = true
	Activity_9001687_RedPacketPanel.super.ctor(self, ...)
	print("Activity_9001687_RedPacketPanel:ctor", self.viewName)
end
function Activity_9001687_RedPacketPanel:onInit()
	print("=======Activity_9001687_RedPacketPanel:onInit")
	self.fields.text_record:setString(i18n("common_text_1782"))
	self.fields.text_record:addEventListener(fgui.UIEventType.Click, handler(self, self.onClickRecord))
	self.fields.Button_normal:setTitle(i18n("Frosty_Carnival_text_11"))
	self.fields.Button_normal:addClickEventListener(handler(self, self.onClickGet))
	self.fields.mv_light:setAllFrameNameOnce("dh_zhaiyueqd7_%.3d.png", 0, true)
	self.fields.mv_light2:setAllFrameNameOnce("dh_zhaiyueqd7_%.3d.png", 0, true)
	self.fields.Label_time:setTimeEndListener(function()
		self:close()
	end)
end
function Activity_9001687_RedPacketPanel:endShow()
	print("=======Activity_9001687_RedPacketPanel:endShow")
	self:updateView(self.param.redPacketInfo)
end
function Activity_9001687_RedPacketPanel:updateView(data)
	self.itemData = data
	local iconID = self.itemData.iconid
	local avatar = self.itemData.avatar
	self.fields.Com_head:setHeadSprite(iconID, avatar)
	local mailFunctions = include("mailFunctions")
	local name = self.itemData.nickname
	if self.itemData.type == 2 then
		name = mailFunctions:getWrappedName(self.itemData.allianceAbbr, self.itemData.nickname)
	end
	local defaultStr = i18n("common_text_1863")
	if self.itemData.npcId then
		name = chatFunctions:getNpcName(self.itemData.npcId)
	end
	name = string.format([[
%s
%s]], name, defaultStr or "")
	self.fields.text_name:setString(name)
	dump(self.itemData, "self.itemData")
	self.fields.Label_time:beginTime(self.itemData.begintime + self.itemData.checkTime - serviceFunctions.systemTime())
end
function Activity_9001687_RedPacketPanel:onClickRecord()
	SoraDPlaySound()
	local rid = self.itemData.RID
	local uid = self.itemData.uid
	print("TODO：申请打开详情界面-------uid = ", uid, ",  rid = ", rid)
	SoraDShowLoading()
	redenvelopesCtrl:sendCheck(uid, rid)
	chatRedPacketMgr:setIsReqViewRedPacket(true)
	self:close()
end
function Activity_9001687_RedPacketPanel:onClickGet()
	SoraDPlaySound()
	local rid = self.itemData.RID
	print("TODO: 发起抢红包请求------", rid)
	SoraDShowLoading()
	local playerId = chatFunctions:getSelfId()
	redenvelopesCtrl:sendGet(playerId, rid)
end
return Activity_9001687_RedPacketPanel
