_ENV = nil
;(nil).colorRank = cc.c3b(200, 170, 150)
local (nil).colorGray, _defaultParam = cc.c3b(120, 120, 120), nil
local nodeStageRankBottom = class("nodeStageRankBottom", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("nodeStageRankBottom")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function nodeStageRankBottom:ctor()
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
	self.textRewardNum = SoraDGetChildByName(self, "text_reward_num")
	SoraDSetTextWidthHeight(self.textRewardNum, cc.size(120, 26))
	self.textRewardNum:setPositionX(SoraDFPosX(105))
	self.frameMainDecoration1 = SoraDGetChildByName(self, "frame_main_decoration_1")
	self.frameMainDecoration2 = SoraDGetChildByName(self, "frame_main_decoration_2")
end
function nodeStageRankBottom:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function nodeStageRankBottom:init(data)
	if not data then
		self:updateNoRank()
		return
	end
	self.data = data
	self:updateBaseInfo()
end
function nodeStageRankBottom:updateNoRank()
	self.txtName:setString(i18n("herobattle_text_05"))
	_UPVALUE2_ = self.txtName
	self.txtName[1] = self.nodeHead
	self.txtName[2] = self.spIndex
	SoraDSetNodeArrayVisible(self.txtName)
end
function nodeStageRankBottom:updateBaseInfo()
	local rank = self.data.rank
	self.textMyRank:setVisible(rank > RANK_TOP_SPECIAL)
	self.spIndex:setVisible(rank <= RANK_TOP_SPECIAL)
	self.textMyRank:setString(tostring(rank))
	if rank <= RANK_TOP_SPECIAL then
		self.spIndex:setSpriteFrame("icon_ranking_" .. rank .. ".png")
	end
	local uinfo = self.data
	self.txtName:setString(uinfo.nickName)
	if self.data.isQuit then
		self.textMyRank:setString("Quit")
		self.textMyRank:setColor(_defaultParam.colorGray)
		self.spIndex:setVisible(false)
		self.textMyRank:setVisible(true)
	end
	SoraDGetHeadFromManager(self.headIcon, uinfo.iconID, uinfo.avatar)
	self.textRewardNum:setString(string.formatnumberthousands(self.data.score))
	self.textRewardNum:setVisible(true)
end
function nodeStageRankBottom:onMessageListener()
end
return nodeStageRankBottom
