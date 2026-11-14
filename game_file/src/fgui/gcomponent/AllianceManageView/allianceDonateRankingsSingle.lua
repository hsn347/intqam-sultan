local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local allianceDonateRankingsSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceManageView/allianceDonateRankingsSingle", allianceDonateRankingsSingle)
function allianceDonateRankingsSingle:onInit()
	self.fields.Btn_touch:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Load_bg:fix()
	self:fixChildrenPos()
end
function allianceDonateRankingsSingle:onShow()
end
function allianceDonateRankingsSingle:initData(data, rank, rType)
	self.curMember = data
	local isSelf = self.curMember:getProperty("uid") == lordInfoCtrl:getLordInfo().base.uid
	local index = 0
	if rank <= RANK_TOP_SPECIAL then
		index = rank
	elseif isSelf then
		index = 4
	end
	self.controllers.c1:setSelectedIndex(index)
	if rank <= 0 then
		self.fields.Text_rank:setString(i18n("common_text_827"))
	else
		self.fields.Text_rank:setString(rank)
	end
	self.fields.Com_head:setHeadSprite(self.curMember:getProperty("iconID"), self.curMember:getProperty("avatar"))
	self.fields.Com_head:setPlayerID(self.curMember:getProperty("uid"))
	self.fields.Text_name:setString(self.curMember:getProperty("nickName"))
	local donateKey = "sciPointDay"
	local honorKey = "honorDay"
	if rType == gARankType.WEEK then
		donateKey = "sciPointWeek"
		honorKey = "honorWeek"
	elseif rType == gARankType.HISTORY then
		donateKey = "sciPointTotal"
		honorKey = "honorTotal"
	end
	self.fields.Text_donate:setString(string.formatnumberthousands(self.curMember:getProperty(donateKey)))
	self.fields.Text_honor:setString(string.formatnumberthousands(self.curMember:getProperty(honorKey)))
end
function allianceDonateRankingsSingle:btnClickCallBack()
	SoraDPlaySound()
	if self.curMember:getProperty("uid") == lordInfoCtrl:getLordInfo().base.uid then
		SoraDOpenLordView(lordInfoCtrl:getLordInfo())
	else
		local chatConst = include("chatConst")
		local chatFunctions = include("chatFunctions")
		local funUnlockRead = include("funUnlockRead")
		local memberMgr = SoraDGetCtrl("memberMgr")
		_UPVALUE2_ = "memberMgr"
		;("memberMgr")[1] = chatConst.OpId.OpSendEmail
		local ("memberMgr")[2], menuData = chatConst.OpId.OpViewInfo, "memberMgr"
		local bIsShield = chatFunctions.getIsShield(self.curMember:getProperty("uid"))
		if bIsShield == true then
			table.insert(menuData, chatConst.OpId.OpUnShield)
		elseif bIsShield == false then
			table.insert(menuData, chatConst.OpId.OpShield)
		end
		if SoraDGetCastleLv() >= funUnlockRead.getUnlockLevel(gFunBuildKey.FLOWER) then
			table.insert(menuData, chatConst.OpId.OpSendFlower)
		end
		local member = memberMgr:getOwnMember()
		local ownRank = member:getProperty("rank")
		local otherRank = self.curMember:getProperty("rank")
		if ownRank >= gAllianceRank.R4 and ownRank > otherRank then
			table.insert(menuData, chatConst.OpId.OnKickOutAlliance)
		end
		_ENV = "nickName"
		;("nickName").playerId = self.curMember:getProperty("uid")
		;("nickName").nickName = self.curMember:getProperty("nickName")
		;("nickName").allianceAbbr = lordInfoCtrl:getLordInfo().abbr
		SoraDShowPlayerOperatePanel(self.curMember:getProperty("nickName"), menuData, "nickName")
	end
end
return allianceDonateRankingsSingle
