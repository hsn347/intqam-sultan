local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local atlantisBuildPointRank = class("atlantisBuildPointRank", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("atlantisBuildPointRank")
end)
function atlantisBuildPointRank:onEnterPanel()
	SoraDShowLoading(self)
	atlantisWarCtrl:reqFortCmdPostData()
end
function atlantisBuildPointRank:ctor(properties)
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("common_text_2719"))
	self.nodeSingle = SoraDGetChildByName(self, "Node_single")
	self.scrollRank = SoraDGetChildByName(self, "ScrollView_rank")
	self.scrollRank = include("commonAutoScrollList").new(self.scrollRank)
	self.scrollRank:setSingleCreate(handler(self, self.createSingle))
	self.nodeTitle = SoraDGetChildByName(self, "node_title")
	SoraDGetChildByName(self.nodeTitle, "Text_name"):setString(i18n("common_text_264"))
	SoraDGetChildByName(self.nodeTitle, "Text_score"):setString(i18n("common_text_1764"))
	SoraDGetChildByName(self.nodeTitle, "Text_rank"):setString(i18n("common_text_2193"))
	self.textNoRecrod = SoraDGetChildByName(self, "Text_noRecrod")
	self.textNoRecrod:setString(i18n("god_beast_text_16"))
end
function atlantisBuildPointRank:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_FORTCMDPOSTDATA", handler(self, self.msgCallBack))
end
function atlantisBuildPointRank:initData(buildId)
	self.buildID = buildId
end
function atlantisBuildPointRank:createSingle()
	local rankSingle = include("commonRankingSingle").new(self.nodeSingle:clone())
	return rankSingle
end
function atlantisBuildPointRank:msgCallBack(target, data)
	SoraDCloseLoading(self)
	self:getRankData(data.rspdata[tostring(self.buildID)])
	if self.rankData and next(self.rankData) then
		self.scrollRank:setVisible(true)
		_ENV = nil
		;(nil).scroll = self.scrollRank
		;(nil).view = self
		self.scrollRank:updateScrollView(cc.size(544, 102), self.rankData, 1, nil)
		self.textNoRecrod:setVisible(false)
	else
		self.scrollRank:setVisible(false)
		self.textNoRecrod:setVisible(true)
	end
end
function atlantisBuildPointRank:getRankData(infoData)
	if not infoData or not infoData.campScore then
		local _ENV, data = infoData.campScore, infoData.campScore
	end
	dump(data, "MESSAGE_ATLANTISWAR_FORTCMDPOSTDATA")
	table.sort(data, function(l, r)
		local scoreL = l.score or 0
		local scoreR = r.score or 0
		if scoreL ~= scoreR then
			return scoreL > scoreR
		else
			return l.camp < r.camp
		end
	end)
	self.rankData, _ENV = table.sort, table.sort
	local selfRank = 0
	for i, v in ipairs(data) do
		if v.kid == lordInfoCtrl:getMapSourceKid() then
			selfRank = i
		end
	end
	for i, v in ipairs(data) do
		_ENV = lordInfoCtrl
		lordInfoCtrl.selfRank = selfRank
		lordInfoCtrl.rank = i
		lordInfoCtrl.score = v.score or 0
		lordInfoCtrl.model = 3
		_ENV, lordInfoCtrl.lineOneName = serviceFunctions.getKingdomFormatName(v.kingdomName, v.kid), serviceFunctions.getKingdomFormatName(v.kingdomName, v.kid)
		lordInfoCtrl.player, serviceFunctions.getKingdomFormatName(v.kingdomName, v.kid).flag = serviceFunctions.getKingdomFormatName(v.kingdomName, v.kid), v.flag
		table.insert(self.rankData, lordInfoCtrl)
	end
end
return atlantisBuildPointRank
