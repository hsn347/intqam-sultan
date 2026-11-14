local allianceHuntDesRead = include("allianceHuntDesRead")
local nodeRankBottom = class("nodeRankBottom", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("nodeRankBottom")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function nodeRankBottom:ctor()
	self:createUI()
	self.bottomBg1 = SoraDGetChildByName(self, "bottomBg_1")
	self.bottomBg = SoraDGetChildByName(self, "bottomBg")
	self.nodeHead = SoraDGetChildByName(self, "Node_head")
	self.headBase = SoraDGetChildByName(self, "head_base")
	self.headIcon = SoraDGetChildByName(self, "head_icon")
	self.headFrame = SoraDGetChildByName(self, "head_frame")
	self.nodeInfo = SoraDGetChildByName(self, "node_info")
	self.spIndex = SoraDGetChildByName(self, "Sprite_index")
	self.textMyRank = SoraDGetChildByName(self, "text_my_rank")
	self.txtName = SoraDGetChildByName(self, "Text_name")
	self.txtDate = SoraDGetChildByName(self, "Text_date")
	self.textRewardNum = SoraDGetChildByName(self, "text_reward_num")
	self.iconReward = SoraDGetChildByName(self, "icon_reward")
end
function nodeRankBottom:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function nodeRankBottom:init(data)
	if not data then
		self:updateNoRank()
		return
	end
	self.data = data
	self:updateBaseInfo()
end
function nodeRankBottom:updateNoRank()
	self.txtName:setString(i18n("alliance_hunt_text_17"))
	_UPVALUE3_ = self.txtName
	self.txtName[1] = self.nodeHead
	self.txtName[2] = self.spIndex
	self.txtName[3] = self.iconReward
	SoraDSetNodeArrayVisible(self.txtName)
end
function nodeRankBottom:updateBaseInfo()
	local rank = self.data.rankData.rank
	self.textMyRank:setVisible(rank > RANK_TOP_SPECIAL)
	self.spIndex:setVisible(rank <= RANK_TOP_SPECIAL)
	self.textMyRank:setString(tostring(rank))
	if rank <= RANK_TOP_SPECIAL then
		self.spIndex:setSpriteFrame("icon_ranking_" .. rank .. ".png")
	end
	if self.data.rankType == HUNTING_RANK_TYPE.PLAYER then
		local uinfo = self.data.rankData.uinfo
		self.txtName:setString(uinfo.nickName)
		SoraDGetHeadFromManager(self.headIcon, uinfo.iconID, uinfo.avatar)
	else
		self.txtName:setString("Robot")
	end
	self.txtDate:setString(self.data.rankData.score)
	local iconRewardNum = allianceHuntDesRead.getChanllengePointByRank(rank)
	self.textRewardNum:setString(iconRewardNum)
	self.textRewardNum:setVisible(true)
	self.iconReward:setVisible(true)
end
function nodeRankBottom:onMessageListener()
end
return nodeRankBottom
