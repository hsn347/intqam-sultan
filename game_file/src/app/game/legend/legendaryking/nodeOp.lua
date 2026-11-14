_ENV = nil
_ENV = nil
;(nil).icon = "icon_legendaryking_honer.png"
_ENV, (nil).title = nil, "legendaryking_name_01"
;(nil).x = 7
;(nil)[gLegendOpType.OP_REWARD], (nil).offset, (nil).y = nil, nil, -2
_ENV = nil
;(nil).icon = "icon_legendaryking_courtrybuff.png"
_ENV, (nil).title = nil, "common_text_4216"
;(nil).x = 4
;(nil)[gLegendOpType.OP_KINGDOM], (nil).offset, (nil).y = nil, nil, 0
_ENV = nil
;(nil).icon = "icon_legendary_10.png"
;(nil)[gLegendOpType.OP_WORLD], (nil).title = nil, "common_text_4217"
_ENV = nil
;(nil).icon = "icon_legendaryking_award.png"
_ENV, (nil).title = nil, "common_text_4218"
;(nil).x = 3
;(nil)[gLegendOpType.OP_GIFT], (nil).offset, (nil).y = nil, nil, 5
_ENV = nil
;(nil).icon = "icon_legendary_01.png"
;(nil)[gLegendOpType.OP_HISTORY], (nil).title = nil, "common_text_4231"
_ENV = nil
;(nil).icon = "btn_world_kingrank.png"
;(nil)[gLegendOpType.OP_WAR_RANK], (nil).title = nil, "common_text_4232"
_ENV = nil
;(nil).icon = "icon_set_seting2.png"
;(nil)[gLegendOpType.OP_MANAGE], (nil).title = nil, "common_text_4215"
_ENV = nil
;(nil).icon = "icon_building_alliance_war.png"
_ENV, (nil).title = nil, "legendaryking_title_05"
;(nil).x = 7
;(nil)[gLegendOpType.OP_ARMY], (nil).offset, (nil).y = nil, nil, -6
_ENV = nil
;(nil).icon = "btn_yhzd_enter.png"
;(nil).title = "heroicSouls_text_1"
_ENV, (nil)[gLegendOpType.OP_LAND], (nil).scale = gLegendOpType.OP_LAND, nil, 1.3
local opCfg
_ENV = nil
;(nil).icon = "icon_legendaryking_honer.png"
_ENV, (nil).title = nil, "kingstarbattle_text_30"
;(nil).x = 7
gLegendOpType.OP_LAND[gLegendOpType.OP_REWARD], (nil).offset, (nil).y = nil, nil, -2
_ENV = nil
;(nil).icon = "icon_legendaryking_courtrybuff.png"
_ENV, (nil).title = nil, "common_text_4216"
;(nil).x = 4
gLegendOpType.OP_LAND[gLegendOpType.OP_KINGDOM], (nil).offset, (nil).y = nil, nil, 0
_ENV = nil
;(nil).icon = "icon_legendary_10.png"
gLegendOpType.OP_LAND[gLegendOpType.OP_WORLD], (nil).title = nil, "common_text_4217"
_ENV = nil
;(nil).icon = "icon_legendaryking_award.png"
_ENV, (nil).title = nil, "kingstarbattle_text_31"
;(nil).x = 3
gLegendOpType.OP_LAND[gLegendOpType.OP_GIFT], (nil).offset, (nil).y = nil, nil, 5
_ENV = nil
;(nil).icon = "icon_kingstarbattle_01.png"
gLegendOpType.OP_LAND[gLegendOpType.OP_HISTORY], (nil).title = nil, "kingstarbattle_text_27"
_ENV = nil
;(nil).icon = "btn_world_kingrank.png"
gLegendOpType.OP_LAND[gLegendOpType.OP_WAR_RANK], (nil).title = nil, "common_text_4232"
_ENV = nil
;(nil).icon = "icon_set_seting2.png"
gLegendOpType.OP_LAND[gLegendOpType.OP_MANAGE], (nil).title = nil, "kingstarbattle_text_28"
_ENV = nil
;(nil).icon = "icon_building_alliance_war.png"
_ENV, (nil).title = nil, "kingstarbattle_text_32"
;(nil).x = 7
gLegendOpType.OP_LAND[gLegendOpType.OP_ARMY], (nil).offset, (nil).y = nil, nil, -6
_ENV = nil
;(nil).icon = "btn_yhzd_enter.png"
;(nil).title = "heroicSouls_text_1"
gLegendOpType.OP_LAND[gLegendOpType.OP_LAND], (nil).scale = nil, 1.3
local kingStarOpCfg = gLegendOpType.OP_LAND
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
	self.Btn_Op:setSwallowTouches(false)
	self.oriPos = cc.p(self.icon_op:getPosition())
end
function NodeOp:createUI()
end
function NodeOp:init(data)
	local id = data.id
	local cfg = worldMapDefine.isKingStarMapId(data.mapid) and kingStarOpCfg[id] or opCfg[id]
	self.icon_op:loadTexture(cfg.icon, ccui.TextureResType.plistType)
	if cfg.offset then
		self.icon_op:setPositionX(self.oriPos.x + cfg.offset.x)
		self.icon_op:setPositionY(self.oriPos.y + cfg.offset.y)
	end
	local iconScale = cfg.scale or 1.0
	self.icon_op:setScale(iconScale)
	self.Btn_Op:setTag(tonumber(id))
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
