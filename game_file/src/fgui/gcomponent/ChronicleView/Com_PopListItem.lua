local gametop = gModuleMgr.getObject("gametop")
local legendMCtrl = gametop.playertop_:getModule("legendMCtrl")
local allianceDesRead = include("allianceDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_PopListItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ChronicleView/Com_PopListItem", Com_PopListItem)
function Com_PopListItem:onInit()
	local nodeFlag = display.newNode()
	nodeFlag:setScale(0.3)
	nodeFlag:setName("Node_flag")
	self.fields.Loader3D_flag:setContent(nodeFlag)
	self.nodeFlag = nodeFlag
	self.fields.frameRankBg:addClickListener(handler(self, self.onClick_btnBg))
end
function Com_PopListItem:onShow()
end
function Com_PopListItem:initData(data)
	dump(data, "legendMPopListItem:initData(data)", 10)
	self.data = data
	self.serverData = self.data.data
	if self.serverData.uid then
		self:initPlayer()
	else
		self:initAlliance()
	end
end
function Com_PopListItem:initPlayer()
	self.fields.Com_head:setVisible(true)
	self.fields.Loader3D_flag:setVisible(false)
	self.fields.Com_head:setHeadSprite(self.serverData.iconID, self.serverData.avatar)
	self.fields.Text_Name:setString(self.serverData.nickName)
	local strFull = legendMCtrl:getHistoryYearFull(self.serverData.time, true)
	self.fields.Text_Time:setString(strFull)
end
function Com_PopListItem:initAlliance()
	self.fields.Com_head:setVisible(false)
	self.fields.Loader3D_flag:setVisible(true)
	self.nodeFlag:removeAllChildren()
	allianceDesRead.getFlagWithParticle(self.serverData.flag, self.nodeFlag)
	allianceDesRead = nil
	;(nil).abbr = self.serverData.abbr
	;(nil).name = self.serverData.name
	allianceDesRead = nil
	;(nil).name = self.serverData.leaderName or "NA"
	self.fields.Text_Name:setString(i18n("common_text_186", nil) .. "\n" .. i18n("common_text_170", nil))
	local strFull = legendMCtrl:getHistoryYearFull(self.serverData.time, true)
	self.fields.Text_Time:setString(strFull)
end
function Com_PopListItem:queryInfo(data)
	if data.uid then
		self:queryPlayerInfo(data)
	else
		self:queryAllianceInfo(data)
	end
end
function Com_PopListItem:queryPlayerInfo(data)
	if data then
		local playerID = data.uid
		if playerID == 0 then
			return
		end
		local kid = data.sourceKid
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		gametop = nil
		;(nil).targetName = "LegendMPopList"
		lordInfoCtrl:getLordInfoByUid(playerID, kid, nil)
		SoraDShowLoading()
	end
end
function Com_PopListItem:queryAllianceInfo(data)
	local allianceQuery = gametop.playertop_:getModule("allianceQuery")
	SoraDShowLoading()
	gametop = nil
	gametop, (nil).aid = data.aid, data.aid
	data.aid.from = "LegendMPopList"
	allianceQuery:reqAllianceByID(nil, data.aid)
end
function Com_PopListItem:onClick_btnBg()
	SoraDPlaySound()
	self:queryInfo(self.serverData)
end
return Com_PopListItem
