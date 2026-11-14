local chatFunctions = include("chatFunctions")
_ENV = "chatFunctions"
;("chatFunctions").colorRank = cc.c3b(200, 170, 150)
local ("chatFunctions").colorGray, _defaultParam = cc.c3b(120, 120, 120), "chatFunctions"
local nodeStageRankItem = class("nodeStageRankItem", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("nodeStageRankItem")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function nodeStageRankItem:ctor()
	self:createUI()
	self.nodeRank = SoraDGetChildByName(self, "Node_rank")
	self.frameRankBg = SoraDGetChildByName(self, "frame_rank_bg")
	self.frameRank = SoraDGetChildByName(self, "frame_rank")
	self.nodeHead = SoraDGetChildByName(self, "Node_head")
	self.frameLegendaryKingHeadBase2 = SoraDGetChildByName(self, "frame_LegendaryKing_head_base_2")
	self.iconHead = SoraDGetChildByName(self, "icon_head")
	self.frameHead = SoraDGetChildByName(self, "frame_head")
	self.nodeInfo1 = SoraDGetChildByName(self, "Node_info1")
	self.txtName = SoraDGetChildByName(self, "Text_name")
	self.spRank = SoraDGetChildByName(self, "Sprite_Rank")
	self.textMyRank = SoraDGetChildByName(self, "text_my_rank")
	self.textRewardNum = SoraDGetChildByName(self, "text_reward_num")
	if self.frameRank then
		self.frameRank:setSwallowTouches(false)
		self.frameRank:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function nodeStageRankItem:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function nodeStageRankItem:initData(data)
	self.data = data
	dump(self.data, "nodeStageRankItem:initData(data)")
	self:updateBaseInfo()
end
function nodeStageRankItem:updateBaseInfo()
	local rank = self.data.rank
	self.spRank:setVisible(true)
	self.textMyRank:setVisible(true)
	self.textMyRank:setVisible(rank > RANK_TOP_SPECIAL)
	self.spRank:setVisible(rank <= RANK_TOP_SPECIAL)
	self.textMyRank:setString(tostring(rank))
	if rank <= RANK_TOP_SPECIAL then
		self.spRank:setSpriteFrame("icon_ranking_" .. rank .. ".png")
	end
	if self.data.isQuit then
		self.textMyRank:setString("Quit")
		self.textMyRank:setColor(_defaultParam.colorGray)
		self.spRank:setVisible(false)
		self.textMyRank:setVisible(true)
	else
		self.textMyRank:setColor(_defaultParam.colorRank)
	end
	local uinfo = self.data
	self.txtName:setString(uinfo.nickName)
	SoraDGetHeadFromManager(self.iconHead, uinfo.iconID, uinfo.avatar)
	self.textRewardNum:setString(string.formatnumberthousands(self.data.score))
	self:updateBg()
end
function nodeStageRankItem:onMessageListener()
end
function nodeStageRankItem:updateBg()
	self.frameRankBg:setVisible(true)
	if self.data.isQuit then
		self.frameRankBg:setSpriteFrame("frame_alliance_pank_05.png")
		return
	end
	local selfID = chatFunctions:getSelfId()
	local rank = self.data.rank
	if selfID == self.data.uid and rank > RANK_TOP_SPECIAL then
		self.frameRankBg:setSpriteFrame("frame_alliance_pank_05.png")
	elseif rank <= RANK_TOP_SPECIAL then
		self.frameRankBg:setSpriteFrame("frame_alliance_pank_0" .. rank .. ".png")
	else
		self.frameRankBg:setSpriteFrame("frame_alliance_pank_04.png")
	end
end
function nodeStageRankItem:setHandle(handle)
	self.handle = handle
end
function nodeStageRankItem:setScroll(scroll)
	self.scroll = scroll
end
function nodeStageRankItem:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.handle then
			self.handle(self.data)
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	elseif type == ccui.TouchEventType.began then
		self.singleIsMoved = false
	end
end
return nodeStageRankItem
