local lordLocalData = include("lordLocalData")
_ENV = "lordLocalData"
;("lordLocalData").LEGEND = 1
;("lordLocalData").HEGEMON = 2
local ("lordLocalData").KINGSTAR, ViewType = 3, "lordLocalData"
local headBig = class("headBig", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("headBig")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function headBig:ctor()
	self:createUI()
	self.Node_head = SoraDGetChildByName(self, "Node_head")
	self.head_base = SoraDGetChildByName(self, "head_base")
	self.head_frame = SoraDGetChildByName(self, "head_frame")
	self.Sprite_head = SoraDGetChildByName(self, "Sprite_head")
	self.icon_chat_king = SoraDGetChildByName(self, "icon_chat_king")
end
function headBig:createUI()
end
function headBig:init(data)
	if data then
		self.Sprite_head:setVisible(true)
		local headImg = lordLocalData.getHead(data.imageId)
		SoraDGetHeadFromManager(self.Sprite_head, data.imageId, data.avatar)
	else
		self.Sprite_head:setVisible(false)
	end
end
function headBig:setViewType(viewType)
	self.viewType = viewType
	if viewType == ViewType.LEGEND then
		self.head_frame:setSpriteFrame("4086.png")
		if self.icon_chat_king then
			self.icon_chat_king:setSpriteFrame("icon_legendary_01.png")
		end
	elseif viewType == ViewType.HEGEMON then
		self.head_frame:setSpriteFrame("4120.png")
		if self.icon_chat_king then
			self.icon_chat_king:setSpriteFrame("icon_bazhuzhizhan_01.png")
			self.icon_chat_king:setScale(0.5)
		end
	elseif viewType == ViewType.KINGSTAR then
		self.head_frame:setSpriteFrame("headframe_96.png")
		if self.icon_chat_king then
			self.icon_chat_king:setSpriteFrame("icon_kingstarbattle_01.png")
		end
	end
end
function headBig:onMessageListener()
end
return headBig
