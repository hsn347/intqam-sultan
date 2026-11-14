local baseComponent = require("fgui.base.baseComponent")
local allianceHuntDesRead = include("allianceHuntDesRead")
local nodeRankBottom = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceHuntView/nodeRankBottom", nodeRankBottom)
function nodeRankBottom:onInit()
	self:fixChildrenPos()
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
	self.txtNoMessage = SoraDGetChildByName(self, "Text_nodeMessage")
	self.txtDate = SoraDGetChildByName(self, "Text_date")
	self.textRewardNum = SoraDGetChildByName(self, "text_reward_num")
	self.iconReward = SoraDGetChildByName(self, "icon_reward")
	self.rankBg = SoraDGetChildByName(self, "rank_bg")
end
function nodeRankBottom:onShow()
end
function nodeRankBottom:init(data, isChallenge)
	if not data then
		self:updateNoRank()
		return
	end
	self.isChallenge = isChallenge
	self.data = data
	self:updateBaseInfo()
end
function nodeRankBottom:updateNoRank()
	self.txtNoMessage:setVisible(true)
	self.txtNoMessage:setString(i18n("alliance_hunt_text_17"))
	_UPVALUE3_ = self.txtNoMessage
	self.txtNoMessage[1] = self.nodeHead
	self.txtNoMessage[2] = self.spIndex
	self.txtNoMessage[3] = self.iconReward
	SoraDSetNodeArrayVisible(self.txtNoMessage)
end
function nodeRankBottom:updateBaseInfo()
	local rank = self.data.rankData.rank
	self.textMyRank:setVisible(rank > RANK_TOP_SPECIAL)
	self.spIndex:setVisible(rank <= RANK_TOP_SPECIAL)
	self.rankBg:setVisible(rank > RANK_TOP_SPECIAL)
	self.textMyRank:setString(tostring(rank))
	if rank <= RANK_TOP_SPECIAL then
		self.spIndex:setSpriteFrame("icon_ranking_" .. rank .. ".png")
	end
	if self.data.rankType == HUNTING_RANK_TYPE.PLAYER then
		local uinfo = self.data.rankData.uinfo
		self.txtName:setString(uinfo.nickName)
		self.nodeHead:setHeadSprite(uinfo.iconID, uinfo.avatar)
	else
		self.txtName:setString("Robot")
	end
	self.txtDate:setString(self.data.rankData.score)
	if self.isChallenge then
		self.textRewardNum:setVisible(false)
		self.iconReward:setVisible(false)
	else
		local iconRewardNum = allianceHuntDesRead.getChanllengePointByRank(rank)
		self.textRewardNum:setString(iconRewardNum)
		self.textRewardNum:setVisible(true)
		self.iconReward:setVisible(true)
	end
end
function nodeRankBottom:onMessageListener()
end
return nodeRankBottom
