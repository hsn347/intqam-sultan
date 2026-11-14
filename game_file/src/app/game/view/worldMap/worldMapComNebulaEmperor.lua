local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local nebulaEmperorRead = include("nebulaEmperorRead")
local nebulaEmperorUtil = include("nebulaEmperorUtil")
local worldMapComNebulaEmperor = class("worldMapComNebulaEmperor", include("worldMapCom"))
function worldMapComNebulaEmperor:ctor()
	worldMapComNebulaEmperor.super.ctor(self, "worldMapComNebulaEmperor")
end
function worldMapComNebulaEmperor:init()
	self:initWidget()
end
function worldMapComNebulaEmperor:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_NEBULAWAR_REFRESH_WARDATA", handler(self, self.refreshWarData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.onMsgCommonRefresh))
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_ENERGY_EXCHANGE", handler(self, self.updateBtnEnergyState))
	SoraDAddMessage(self, "MESSAGE_NEBULA_EMPEROR_BUFFE_NERGY", handler(self, self.updateBtnEnergyState))
	self:doReqestData()
end
function worldMapComNebulaEmperor:initWidget(...)
	self.Node_war = SoraDGetChildByName(self.target_, "Node_war")
	self.Node_war:setPositionY(display.iPhoneXBottom - 40)
	_UPVALUE3_ = self.Node_war
	self.Node_war[1] = "Button_donate"
	self.Node_war[2] = "Button_energy"
	self.Node_war[3] = "Button_quitBattle"
	for __, v in ipairs(self.Node_war) do
		self[v] = SoraDGetChildByName(self.Node_war, v)
		self[v]:addTouchEventListener(handler(self, self.onClickBtn))
	end
	self.Button_quitBattle:setTitleText(i18n("common_text_3351"))
	self.Sprite_red = SoraDGetChildByName(self.Button_energy, "Sprite_red")
	if self.Sprite_red == nil then
		self.Sprite_red = display.newSprite("#icon_liaotian_red.png")
		self.Sprite_red:setPosition(70, 70)
		self.Sprite_red:addTo(self.Button_energy, 2)
	end
	self.Sprite_red:setVisible(false)
	local Sprite_donate = SoraDGetChildByName(self.Button_donate, "Sprite_donate")
	Sprite_donate:setSpriteFrame("icon_xydw_zjm_jx.png")
	local Sprite_energy = SoraDGetChildByName(self.Button_energy, "Sprite_energy")
	Sprite_energy:setSpriteFrame("icon_xydw_nljc.png")
	Sprite_energy:setScale(0.88)
end
function worldMapComNebulaEmperor:doReqestData(...)
	local mapId = worldMapDefine.currentMapKindomID
	nebulaEmperorCtrl:reqWarData(mapId)
end
function worldMapComNebulaEmperor:refreshWarData(...)
	self:createMapTip()
	if nebulaEmperorUtil.checkActivityState(ACTIVITY_STATE.ACTIVE) then
		self.Button_quitBattle:setVisible(false)
		self.Button_donate:setVisible(true)
		self.Button_energy:setVisible(true)
		self:updateBtnEnergyState()
	else
		self.Button_quitBattle:setVisible(true)
		self.Button_donate:setVisible(false)
		self.Button_energy:setVisible(false)
	end
end
function worldMapComNebulaEmperor:createMapTip()
	if self.pyramidTip then
		return
	end
	local Z_ORDER = worldMapDefine.Z_ORDER
	local height = display.height + display.iPhoneXBottom
	local pyramidTip = include("worldMapPyramidTip").new()
	pyramidTip:setPosition(cc.p(display.cx, height - 270))
	pyramidTip:addTo(self.target_, Z_ORDER.topTipView)
	self.pyramidTip = pyramidTip
end
function worldMapComNebulaEmperor:getNodeWar()
	return self.Node_war
end
function worldMapComNebulaEmperor:onClickBtn(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button == self.Button_donate then
			local donateInfo = nebulaEmperorCtrl:getDonateInfo()
			local donateLv = nebulaEmperorRead.getDonateLv(donateInfo.donateGold)
			_ENV = nil
			;(nil).donateLv = donateLv
			uiManager:show("NebulaEmperorDonateSkill", nil)
		elseif button == self.Button_energy then
			uiManager:show("NebulaEmperorEnergy")
		elseif button == self.Button_quitBattle then
			self:onClickBtnQuit()
		end
	end
end
function worldMapComNebulaEmperor:onClickBtnQuit(...)
	if not worldMapDefine.isInNebulaEmperor() then
		return
	end
	nebulaEmperorUtil.gotoQuitBattleField()
end
function worldMapComNebulaEmperor:updateBtnEnergyState(...)
	local red = nebulaEmperorCtrl:getEnergyStatusAndNum()
	self.Sprite_red:setVisible(red)
end
function worldMapComNebulaEmperor:onMsgCommonRefresh(target, event)
	if nebulaEmperorCtrl:checkActivityID(event) then
		self:refreshWarData()
	end
end
function worldMapComNebulaEmperor:createFogControl(...)
	local getLineArray = function(area)
		local _ENV, ret
		if area and next(area) then
			_UPVALUE8_ = next(area)
			ret, next(area)[1] = next(area), area.x1
			ret, next(area)[2] = next(area), area.y1
			ret, next(area)[3] = next(area), area.x2 + 1
			ret, next(area)[4] = next(area), area.y1
			ret, next(area)[5] = next(area), area.x1
			ret, next(area)[6] = next(area), area.y2 + 1
			ret, next(area)[7] = next(area), area.x2 + 1
			ret, next(area)[8] = next(area), area.y2 + 1
		end
		return ret
	end
	local parent = self.target_.containerView
	local maxRangX = 300
	_UPVALUE2_, _ENV, (nil).triangles, _ENV, (nil).vertices, _ENV, _ENV = nil, nil, nil, nil, nil, nil, nil
	_UPVALUE2_, (nil).center, (nil)[1] = nil, nil, 0.0
	_UPVALUE2_, (nil).center, (nil)[2] = nil, nil, 0.0
	_UPVALUE2_, (nil).size, (nil)[1] = nil, nil, 10000.0
	_UPVALUE2_, (nil).size, (nil)[2] = nil, nil, 10000.0
	;(nil).colors, _ENV, (nil).bounds, (nil).minPos, (nil)[1] = nil, nil, nil, nil, 0.0
	;(nil).colors, _ENV, (nil).bounds, (nil).minPos, (nil)[2] = nil, nil, nil, nil, 0.0
	local meshCfg
	local index = 0
	local nebulaEmperorRead = include("nebulaEmperorRead")
	for __, v in ipairs(nebulaEmperorRead.nebulaemperormap) do
		if v.type == 4 then
			_UPVALUE4_ = nil
			;(nil)[1] = "x1"
			;(nil)[2] = "y1"
			;(nil)[3] = "x2"
			;(nil)[4] = "y2"
			local areas = serviceFunctions.tableFormat(v.area, nil)
			for __, area in ipairs(areas) do
				local array = getLineArray(area)
				for k, w in ipairs(array) do
					if k % 2 == 0 then
						local r = v.camp * 0.1 - 0.05
						_UPVALUE4_ = nil
						;(nil)[1] = r
						;(nil)[2] = 1.0
						;(nil)[3] = 1.0
						;(nil)[4] = 1.0
						table.insertto(meshCfg.colors, nil)
						w = maxRangX - w
					end
					table.insert(meshCfg.vertices, w)
				end
				_UPVALUE6_ = ipairs(array)
				ipairs(array)[1] = 0
				ipairs(array)[2] = 2
				ipairs(array)[3] = 1
				ipairs(array)[4] = 1
				ipairs(array)[5] = 2
				ipairs(array)[6] = 3
				for _, k in ipairs(ipairs(array)) do
					table.insert(meshCfg.triangles, k + index * 4)
				end
				index = index + 1
			end
		end
	end
	local shader = require("app.shader.allianceTerritoryMeshShader")
	local meshNode1 = SoraDCreateMeshNode(meshCfg, meshCfg.bounds.size, shader)
	meshNode1:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
	local renderTexture1 = cc.RenderTexture:create(maxRangX, maxRangX, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
	renderTexture1:addTo(parent)
	renderTexture1:setPosition(cc.p(display.cx, display.cy))
	renderTexture1:beginWithClear(0, 0, 0, 0)
	meshNode1:visit()
	renderTexture1:endToLua()
	renderTexture1:setVisible(false)
	local tileTexture1 = renderTexture1:getSprite():getTexture()
	tileTexture1:setTexParameters(gl.NEAREST, gl.NEAREST, gl.REPEAT, gl.REPEAT)
	_UPVALUE8_, _ENV = tileTexture1, tileTexture1.setTexParameters
	_UPVALUE8_, tileTexture1.setTexParameters.vertices, tileTexture1[1] = tileTexture1, tileTexture1, 0
	_UPVALUE8_, tileTexture1.setTexParameters.vertices, tileTexture1[2] = tileTexture1, tileTexture1, 0
	_UPVALUE8_, tileTexture1.setTexParameters.vertices, tileTexture1[3] = tileTexture1, tileTexture1, 0
	_UPVALUE8_, tileTexture1.setTexParameters.vertices, tileTexture1[4] = tileTexture1, tileTexture1, maxRangX
	_UPVALUE8_, tileTexture1.setTexParameters.vertices, tileTexture1[5] = tileTexture1, tileTexture1, maxRangX
	_UPVALUE8_, tileTexture1.setTexParameters.vertices, tileTexture1[6] = tileTexture1, tileTexture1, 0
	_UPVALUE8_, tileTexture1.setTexParameters.vertices, tileTexture1[7] = tileTexture1, tileTexture1, maxRangX
	_UPVALUE8_, tileTexture1.setTexParameters.vertices, tileTexture1[8] = tileTexture1, tileTexture1, maxRangX
	_UPVALUE6_, tileTexture1.setTexParameters.uv, tileTexture1[1] = tileTexture1, tileTexture1, 0
	_UPVALUE6_, tileTexture1.setTexParameters.uv, tileTexture1[2] = tileTexture1, tileTexture1, 0
	_UPVALUE6_, tileTexture1.setTexParameters.uv, tileTexture1[3] = tileTexture1, tileTexture1, 0
	_UPVALUE6_, tileTexture1.setTexParameters.uv, tileTexture1[4] = tileTexture1, tileTexture1, 1
	_UPVALUE6_, tileTexture1.setTexParameters.uv, tileTexture1[5] = tileTexture1, tileTexture1, 1
	_UPVALUE6_, tileTexture1.setTexParameters.uv, tileTexture1[6] = tileTexture1, tileTexture1, 0
	_UPVALUE6_, tileTexture1.setTexParameters.uv, tileTexture1[7] = tileTexture1, tileTexture1, 1
	_UPVALUE6_, tileTexture1.setTexParameters.uv, tileTexture1[8] = tileTexture1, tileTexture1, 1
	_UPVALUE2_, _ENV, tileTexture1.setTexParameters.triangles, tileTexture1[1] = 0, tileTexture1, tileTexture1, 0
	_UPVALUE2_, _ENV, tileTexture1.setTexParameters.triangles, tileTexture1[2] = 0, tileTexture1, tileTexture1, 2
	_UPVALUE2_, _ENV, tileTexture1.setTexParameters.triangles, tileTexture1[3] = 0, tileTexture1, tileTexture1, 1
	_UPVALUE2_, _ENV, tileTexture1.setTexParameters.triangles, tileTexture1[4] = 0, tileTexture1, tileTexture1, 1
	_UPVALUE2_, _ENV, tileTexture1.setTexParameters.triangles, tileTexture1[5] = 0, tileTexture1, tileTexture1, 2
	_UPVALUE2_, _ENV, tileTexture1.setTexParameters.triangles, tileTexture1[6] = 0, tileTexture1, tileTexture1, 3
	_UPVALUE2_, tileTexture1.center, (0)[1] = 0, 0, 0.0
	_UPVALUE2_, tileTexture1.center, (0)[2] = 0, 0, 0.0
	_UPVALUE2_, tileTexture1.size, (0)[1] = 0, 0, maxRangX
	_UPVALUE2_, tileTexture1.size, (0)[2] = 0, 0, maxRangX
	_ENV, _ENV, tileTexture1.setTexParameters.bounds, tileTexture1.minPos, (0)[1] = 0, tileTexture1, tileTexture1, 0, 0.0
	_ENV, _ENV, tileTexture1.setTexParameters.bounds, tileTexture1.minPos, (0)[2] = 0, tileTexture1, tileTexture1, 0, 0.0
	local meshCfg = tileTexture1.setTexParameters
	;(0).attr = "#texture"
	;(0).name = "_TileTexture"
	_ENV, tileTexture1[1], (0).value = 0, 0, tileTexture1
	;(0).attr = "float"
	;(0).name = "step_tile"
	tileTexture1[2], (0).value = 0, 1 / maxRangX
	local param = tileTexture1
	local shader = require("app.game.worldMap.shader.fogDraw_emperor_shader")
	local meshNode2 = SoraDCreateMeshNode(meshCfg, meshCfg.bounds.size, shader, param)
	meshNode2:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
	local renderTexture2 = cc.RenderTexture:create(maxRangX, maxRangX, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
	renderTexture2:addTo(parent)
	renderTexture2:setPosition(cc.p(display.cx, display.cy))
	renderTexture2:beginWithClear(0, 0, 0, 0)
	meshNode2:visit()
	renderTexture2:endToLua()
	renderTexture2:saveToFile("res/tileMaps/nebulaEmperor/fogControl.png")
	renderTexture2:setVisible(false)
end
function worldMapComNebulaEmperor:exportMethods()
	_UPVALUE1_ = nil
	;(nil)[1] = "getNodeWar"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComNebulaEmperor
