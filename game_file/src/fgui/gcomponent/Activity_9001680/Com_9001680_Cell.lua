local baseComponent = require("fgui.base.baseComponent")
local Com_9001680_Cell = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001680_Ctrl = SoraDGetCtrl("activity_9001680_Ctrl")
fgui.register_extension("ui://Activity_9001680/Com_9001680_Cell", Com_9001680_Cell)
local activity_9001680_Read = include("activity_9001680_Read")
local MAP_OBJ_TYPE = activity_9001680_Read.MAP_OBJ_TYPE
local MAP_OBJ = activity_9001680_Read.MAP_OBJ
_ENV, _ENV = nil, nil
;(nil).img = "frame_9001680_miwu.png"
_ENV, (nil)[1], (nil).needRd = nil, nil, false
;(nil).img = "frame_9001680_shitou%02d.png"
;(nil).needRd = true
_ENV, (nil)[2], (nil).size = nil, nil, 6
;(nil).img = "frame_9001680_tudi%02d.png"
;(nil).needRd = true
_ENV, (nil)[3], (nil).size = nil, nil, 6
;(nil).img = "frame_9001680_zouguo04.png"
;(nil).needRd = false
_ENV, (nil)[4], (nil).size = nil, nil, 5
local imgCfgs
_ENV = nil
;(nil)[MAP_OBJ_TYPE.UNKNOWN], (nil).imgCfg = nil, imgCfgs[1]
_ENV = nil
;(nil)[MAP_OBJ_TYPE.SOIL], (nil).imgCfg = nil, imgCfgs[3]
_ENV = nil
;(nil)[MAP_OBJ_TYPE.ROCK], (nil).imgCfg = nil, imgCfgs[2]
_ENV = nil
;(nil).imgCfg = imgCfgs[3]
;(nil)[MAP_OBJ_TYPE.MONSTER], (nil).item = nil, "clr_sj_ws_01.png"
_ENV = nil
;(nil).imgCfg = imgCfgs[3]
;(nil)[MAP_OBJ_TYPE.BOSS], (nil).item = nil, "esboss_sj_ws_01.png"
_ENV = nil
;(nil).imgCfg = imgCfgs[3]
;(nil)[MAP_OBJ_TYPE.TREASURE_CLEW], (nil).item = nil, "icon_9001680_xiansuo.png"
_ENV = nil
;(nil)[MAP_OBJ_TYPE.TREASURE], (nil).imgCfg = nil, imgCfgs[3]
_ENV = nil
;(nil).imgCfg = imgCfgs[3]
;(nil)[MAP_OBJ_TYPE.BOX], (nil).item = nil, "icon_9001680_baoxiang.png"
_ENV = nil
;(nil).imgCfg = imgCfgs[3]
;(nil)[MAP_OBJ_TYPE.ORE], (nil).item = nil, "icon_9001680_kuangshi.png"
_ENV = nil
;(nil).imgCfg = imgCfgs[3]
;(nil)[MAP_OBJ_TYPE.GEM], (nil).item = nil, "icon_9001680_baoshikuang.png"
_ENV = nil
;(nil)[MAP_OBJ_TYPE.NONE], (nil).imgCfg = nil, imgCfgs[4]
local imgMap
function Com_9001680_Cell:onInit()
	self.poolObjects, _ENV, self.curObjId = nil, nil, nil
	self:addClickEventListener(handler(self, self.onCellClick))
end
function Com_9001680_Cell:setGameView(gameView)
	self.gameView = gameView
end
function Com_9001680_Cell:onShow()
end
function Com_9001680_Cell:setData(x, y, objId)
	if self.cellX == x and self.cellY == y and objId == self.curObjId then
		self:dealSpecialUIs()
		return
	end
	if self.cellX == x and self.cellY == y then
		self.fields.bgOld:setURL(self.fields.bg:getURL())
		self.fields.bgOld:setVisible(self.cellX == x and self.cellY == y)
		self.transitions.t0:play()
	end
	self.cellX = x
	self.cellY = y
	self.curObjId = objId
	local mapCfg = imgMap[objId]
	self.objCfg = activity_9001680_Read.getElement(objId)
	if mapCfg == nil then
		mapCfg = self.objCfg and imgMap[self.objCfg.type] or nil
	end
	if mapCfg then
		local imgCfg = mapCfg.imgCfg
		if not imgCfg.needRd then
			self.fields.bg:setURL(imgCfg.img)
		else
			self.fields.bg:setURL(string.format(imgCfg.img, (x * 2 + y) % imgCfg.size + 1))
		end
		local image = self.objCfg and self.objCfg.image or ""
		self.fields.item:setVisible(image ~= "" and true or false)
		if image ~= "" then
			self.fields.item:setURL(image)
		end
	else
		print("err map", x, y, objId)
	end
	self:dealSpecialUIs()
end
function Com_9001680_Cell:updateMonster()
end
function Com_9001680_Cell:dealSpecialUIs()
	self:updateEffect()
end
function Com_9001680_Cell:updateEffect()
	if self.objCfg == nil then
		self:putAllEffectToPool()
		return
	end
	local time = 0
	if self.objCfg.dig_time ~= 0 then
		local pickingTime = activity_9001680_Ctrl:getPickingTime(self.cellX, self.cellY)
		time = pickingTime ~= nil and pickingTime - serviceFunctions.systemTime() or 0
	elseif self.objCfg.type == MAP_OBJ_TYPE.BOSS then
		local bossTime, lastTime = activity_9001680_Ctrl:getBossTime()
		time = 0 < bossTime and lastTime - (serviceFunctions.systemTime() - bossTime) or 0
	end
	if 0 < time then
		local cellTime, isNewCreate = self:getEffect("Com_9001680_CellTime")
		local pos = self:getPosition()
		cellTime:setPosition(pos.x, pos.y)
		cellTime:beginTime(time, self.objCfg.dig_time ~= 0)
	else
		self:putEffectToPool("Com_9001680_CellTime")
	end
	if self.objCfg.type == MAP_OBJ_TYPE.TREASURE then
		local effect, isNewCreate = self:getEffect("Ani_box")
		if isNewCreate then
			effect:setAllFrameName("G_activity_9001680_iconfx_%02d.png", 1)
			effect:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
		end
		local pos = self:getPosition()
		effect:setPosition(pos.x - 19, pos.y - 23)
	else
		self:putEffectToPool("Ani_box")
	end
end
function Com_9001680_Cell:getEffect(uiName)
	local effect = self.poolObjects[uiName]
	local isNewCreate
	if effect == nil then
		effect = self.gameView:getComFromPool(uiName, 1000)
		self.poolObjects[uiName] = effect
		isNewCreate = true
	end
	return effect, isNewCreate
end
function Com_9001680_Cell:putEffectToPool(uiName)
	local effect = self.poolObjects[uiName]
	if effect then
		self.gameView:putComToPool(effect, uiName)
		self.poolObjects[uiName] = nil
	end
end
function Com_9001680_Cell:putAllEffectToPool()
	for k, v in pairs(self.poolObjects) do
		self.gameView:putComToPool(v, k)
	end
	self.poolObjects, _ENV = pairs(self.poolObjects)
end
function Com_9001680_Cell:debugPos(debugPos, x, y, objId)
	if debugPos then
		if self.debugLabel == nil then
			_ENV = nil
			;(nil).UILabelType = 2
			;(nil).text = ""
			;(nil).size = 20
			self.debugLabel = SoraDCreateLabelNoChild(nil)
			self.debugLabel:addTo(self)
			self.debugLabel:setPosition(self:getSize().width / 2, self:getSize().width / 2)
		end
		self.debugLabel:setVisible(true)
		self.debugLabel:setString(string.format("%d,%d,%d", x, y, objId))
	elseif self.debugLabel then
		self.debugLabel:setVisible(false)
	end
end
function Com_9001680_Cell:setClickCallback(clickCallback)
	self.clickCallback = clickCallback
end
function Com_9001680_Cell:onCellClick()
	SoraDPlaySound()
	if self.clickCallback then
		self.clickCallback(self, self.cellX, self.cellY, self.curObjId)
	end
end
function Com_9001680_Cell:onPutToPull()
end
return Com_9001680_Cell
