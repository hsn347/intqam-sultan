_ENV = nil
_ENV = nil
;(nil).icon = "icon_hegemon_honer.png"
_ENV, (nil).title = nil, "hegemon_title_01"
;(nil).x = 0
;(nil)[gLegendOpType.OP_REWARD], (nil).offset, (nil).y = nil, nil, 0
_ENV = nil
;(nil).icon = "icon_hegemon_country.png"
_ENV, (nil).title = nil, "hegemon_text_29"
;(nil).x = 0
;(nil)[gLegendOpType.OP_KINGDOM], (nil).offset, (nil).y = nil, nil, 0
_ENV = nil
;(nil).icon = "icon_hegemon_buff.png"
;(nil)[gLegendOpType.OP_WORLD], (nil).title = nil, "hegemon_title_08"
_ENV = nil
;(nil).icon = "icon_hegemon_award.png"
_ENV, (nil).title = nil, "hegemon_title_09"
;(nil).x = 0
;(nil)[gLegendOpType.OP_GIFT], (nil).offset, (nil).y = nil, nil, 0
_ENV = nil
;(nil).icon = "icon_hegemon_king.png"
;(nil)[gLegendOpType.OP_HISTORY], (nil).title = nil, "hegemon_title_10"
_ENV = nil
;(nil).icon = "icon_hegemon_ranking.png"
_ENV, (nil).title = nil, "common_text_4232"
;(nil).x = -5
;(nil)[gLegendOpType.OP_WAR_RANK], (nil).offset, (nil).y = nil, nil, 0
_ENV = nil
;(nil).icon = "icon_set_seting2.png"
;(nil).title = "hegemon_title_07"
;(nil)[gLegendOpType.OP_MANAGE], (nil).noSwallow = nil, true
_ENV = nil
;(nil).icon = "icon_building_alliance_war.png"
_ENV, (nil).title = nil, "hegemon_text_31"
;(nil).x = 2
;(nil)[gLegendOpType.OP_ARMY], (nil).offset, (nil).y = nil, nil, 0
_ENV = nil
;(nil).icon = "icon_hegemon_land_enter.png"
_ENV, (nil).title = nil, "heroicSouls_text_1"
;(nil).x = 0
;(nil)[gLegendOpType.OP_LAND], (nil).offset, (nil).y = nil, nil, 0
local opCfg
local NodeOp = class("NodeOp", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("NodeOp")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function NodeOp:ctor()
	self:createUI()
	self.Node_Content = SoraDGetChildByName(self, "Node_Content")
	self.frame_throne_contend_bottom = SoraDGetChildByName(self, "frame_throne_contend_bottom")
	self.Btn_Op = SoraDGetChildByName(self, "Btn_Op")
	self.icon_op = SoraDGetChildByName(self, "icon_op")
	self.frame_sheer_black = SoraDGetChildByName(self, "frame_sheer_black")
	self.Text_Op = SoraDGetChildByName(self, "Text_Op")
	self.Btn_Op:addTouchEventListener(handler(self, self.onClick_Btn_Op))
	self.oriPos = cc.p(self.icon_op:getPosition())
end
function NodeOp:createUI()
end
function NodeOp:init(data)
	local id = data.id
	local cfg = opCfg[id]
	self.icon_op:loadTexture(cfg.icon, ccui.TextureResType.plistType)
	self.icon_op:ignoreContentAdaptWithSize(true)
	if cfg.offset then
		self.icon_op:setPositionX(self.oriPos.x + cfg.offset.x)
		self.icon_op:setPositionY(self.oriPos.y + cfg.offset.y)
	end
	self.Btn_Op:setTag(tonumber(id))
	self.Btn_Op:setSwallowTouches(cfg.noSwallow or false)
	self.Text_Op:setString(i18n(cfg.title))
	self.handle = data.handle
end
function NodeOp:onMessageListener()
end
function NodeOp:onClick_Btn_Op(sender, event)
	if event == ccui.TouchEventType.began then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = sender:getTouchBeganPosition()
		local touchmovePoint = sender:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.handle then
			self.handle(sender)
		end
	end
end
return NodeOp
