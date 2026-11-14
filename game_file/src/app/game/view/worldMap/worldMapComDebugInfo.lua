local worldMapComDebugInfo = class("worldMapComDebugInfo", include("worldMapCom"))
function worldMapComDebugInfo:ctor()
	worldMapComDebugInfo.super.ctor(self, "worldMapComDebugInfo")
end
local addTestButton = function(parent, x, y, title, fun)
	local btn = SoraDTestButton(parent, fun, true)
	btn:setPosition(x or 0, y or 0)
	btn:setTitleText(title or "go")
	return btn
end
local worldLodDef = worldMapDefine.worldLodDef
_ENV, _UPVALUE7_ = include("worldMapCom")
include("worldMapCom").lod = worldLodDef.LOD1
include("worldMapCom").scale = 1.4
_ENV, include("worldMapCom").name = worldLodDef.LOD1, "LOD1"
worldLodDef.LOD1.lod = worldLodDef.LOD2
worldLodDef.LOD1.scale = 0.65
_ENV, worldLodDef.LOD1.name = worldLodDef.LOD2, "LOD2"
worldLodDef.LOD2.lod = worldLodDef.LOD3
worldLodDef.LOD2.scale = 0.45
_ENV, worldLodDef.LOD2.name = worldLodDef.LOD3, "LOD3"
worldLodDef.LOD3.lod = worldLodDef.LOD4
worldLodDef.LOD3.scale = 0.25
_ENV, worldLodDef.LOD3.name = worldLodDef.LOD4, "LOD4"
worldLodDef.LOD4.lod = worldLodDef.LOD5
worldLodDef.LOD4.scale = 0.08
_ENV, worldLodDef.LOD4.name = worldLodDef.LOD5, "LOD5"
worldLodDef.LOD5.lod = worldLodDef.LOD6
worldLodDef.LOD5.scale = 0.02
_ENV, worldLodDef.LOD5.name = worldLodDef.LOD6, "LOD6"
worldLodDef.LOD6.lod = 7
worldLodDef.LOD6.scale = 0.01
worldLodDef.LOD6.name = "min"
include("worldMapCom")[1] = include("worldMapCom")
include("worldMapCom")[2] = worldLodDef.LOD1
include("worldMapCom")[3] = worldLodDef.LOD2
include("worldMapCom")[4] = worldLodDef.LOD3
include("worldMapCom")[5] = worldLodDef.LOD4
include("worldMapCom")[6] = worldLodDef.LOD5
local include("worldMapCom")[7], worldLodConfig = worldLodDef.LOD6, include("worldMapCom")
for _, v in ipairs(worldLodConfig) do
	v.scaleOld = v.scale
end
local getLodByScale = function(scale)
	for i = #worldLodConfig - 1, 1, -1 do
		if scale <= worldLodConfig[i].scale then
			return worldLodConfig[i].lod
		end
	end
end
function worldMapComDebugInfo:init()
	worldMapComDebugInfo.super.init(self)
	if not self.debugScaleLabel then
		self.debugScaleLabel = ccui.Text:create("", "", 30)
		self.debugScaleLabel:addTo(self.target_, 11111)
		self.debugScaleLabel:setPosition(cc.p(320, display.height / 3 * 2))
		self.debugScaleLabel:setColor(cc.c3b(255, 0, 0))
	end
	local worldMapEvent = include("worldMapEvent")
	self:addEventListener(worldMapEvent.EVENT_SCROLL_ZOOM, handler(self, self.updateMapZoom))
	self:addEventListener(worldMapEvent.EVENT_TILE_POS, handler(self, self.updateTilePos))
	self:addEventListener(worldMapEvent.EVENT_SCROLL_LOD_CHANGE, handler(self, self.updateLodLevel))
	self:addEventListener(worldMapEvent.EVENT_TILED_DEBUG, handler(self, self.toggleDebugLayer))
end
function worldMapComDebugInfo:initDebugLine()
	if not self.debugLine then
		self.debugNode = display.newNode()
		self.debugNode:addTo(self.target_, 11112)
		_UPVALUE2_, _UPVALUE2_ = self.target_, self.debugNode
		_UPVALUE2_, self.target_[1] = display.cx, display.cx
		_UPVALUE2_, self.target_[2] = display.cx, 0
		display.cx[1] = display.cx
		display.cx[2] = display.height
		_ENV, self.debugNode[1] = self.target_, self.target_
		_ENV, self.debugNode[2] = self.target_, display.cx
		self.target_.borderColor = cc.c4f(1.0, 0.0, 0.0, 1.0)
		self.target_.borderWidth = 2
		do
			local line = display.newLine(self.debugNode, self.target_)
			line:addTo(self.debugNode)
		end
		_UPVALUE2_, _UPVALUE2_ = line, line.addTo
		_UPVALUE2_, line[1] = 0, 0
		_UPVALUE2_, line[2] = 0, display.cy
		;(0)[1] = display.width
		;(0)[2] = display.cy
		_ENV, line.addTo[1] = line, line
		_ENV, line.addTo[2] = line, 0
		line.borderColor = cc.c4f(1.0, 0.0, 0.0, 1.0)
		line.borderWidth = 2
		local line = display.newLine(line.addTo, line)
		line:addTo(self.debugNode)
	end
end
function worldMapComDebugInfo:initDebugView()
	if not self.debugNode then
		self.debugScaleLabel:setPosition(cc.p(320, display.height / 3 * 2 + 100))
		self.tableItem = worldLodConfig
		self.index = 1
		self.viewScrollView = self.target_.viewScrollView
		self.debugNode = display.newNode()
		self.debugNode:addTo(self.target_, 11112)
		self.debugNode:setPosition(cc.p(320, display.height / 3 * 2))
		self.debugNode:setName("ScaleConfig")
		self.scaleLabel = ccui.Text:create("", "", 25)
		self.scaleLabel:addTo(self.debugNode, -1)
		self.scaleLabel:setPosition(cc.p(0, -160))
		self.scaleLabel:setColor(cc.c3b(0, 255, 0))
		local updateScaleLable = function()
			local str = ""
			for i, v in ipairs(self.tableItem) do
				local txt
				if i >= #self.tableItem then
					txt = string.format("%s:[%.4f]\n", v.name, v.scale)
				else
					txt = string.format("%s:[%.4f]-[%.4f]\n", v.name, v.scale, self.tableItem[i + 1].scale)
				end
				str = str .. txt
			end
			self.scaleLabel:setString(str)
			self.viewScrollView:setMinScale(self.tableItem[#self.tableItem].scale)
		end
		updateScaleLable()
		addTestButton(self.debugNode, 60, 0, "设置", function()
			local data = self.tableItem[self.index]
			if data then
				local curScale = self.viewScrollView:getZoomScale()
				data.scale = curScale
				updateScaleLable()
			end
		end)
		addTestButton(self.debugNode, 150, 0, "还原", function()
			for _, v in ipairs(worldLodConfig) do
				v.scale = v.scaleOld
			end
			updateScaleLable()
		end)
		local panel_pagramer = include("commonDropBox").new()
		_ENV = 0
		;(0).width = 180
		;(0).singleWidth = 130
		;(0).showPanelHeight = 350
		;(0).sliderHeight = 250
		panel_pagramer:initConfig(0)
		panel_pagramer:initData(self.tableItem)
		panel_pagramer:setPosition(-180, 25)
		panel_pagramer:addTo(self.debugNode, 9)
		panel_pagramer:setName("commonDropBox")
		panel_pagramer:setHandleChoose(function(target, index, data)
			self.index = index
		end)
		panel_pagramer:initView()
		local comLod = self.target_:getComponent("worldMapComLod")
		function comLod.getLodCurrentScale()
			local curScale = self.viewScrollView:getZoomScale()
			local lod = getLodByScale(curScale)
			comLod.lod = lod or 1
			return comLod.lod
		end
	end
end
function worldMapComDebugInfo:onMessageListener()
	fguiHelper.registMouseEvent(self.target_.viewScrollView)
	self:updateMapZoom()
end
function worldMapComDebugInfo:updateMapZoom(event)
	local scale = self.target_.viewScrollView:getZoomScale()
	local str = string.format("当前地图缩放值为: %.4f \n当前地图LOD为: %d", scale, self.target_:getCurLod())
	self.debugScaleLabel:setString(str)
end
function worldMapComDebugInfo:updateTilePos(event)
	if not self.showDebugLayer or not self:checkDebugLayerLod() then
		self.event_tile_pos = event
		return
	end
	local tile = event.tile_pos
	local size = cc.size(10, 10)
	local rect = cc.rect(tile.x - math.floor(size.width / 2), tile.y - math.floor(size.height / 2), size.width, size.height)
	self.debugLayer:updateTile(rect)
end
function worldMapComDebugInfo:updateLodLevel(event)
	if not self.showDebugLayer then
		return
	end
	if self:checkDebugLayerLod() then
		self.debugLayer:setVisible(true)
	else
		self.debugLayer:setVisible(false)
	end
end
function worldMapComDebugInfo:checkDebugLayerLod(...)
	local curLod = self.target_:getCurLod()
	return curLod <= 2
end
function worldMapComDebugInfo:toggleDebugLayer(...)
	if not self:checkDebugLayerLod() then
		return
	end
	self.showDebugLayer = not self.showDebugLayer
	if self.showDebugLayer then
		if not self.debugLayer then
			local worldMapCell = self.target_.currentInMapViewCell
			local debugLayer = SoraDTMXDebugLayer.new(worldMapCell)
			debugLayer:addTo(worldMapCell, -1)
			debugLayer:setGroupID(worldMapDefine.GROU_ID.group_border)
			self.debugLayer = debugLayer
		else
			self.debugLayer:setVisible(true)
		end
		if self.event_tile_pos then
			self:updateTilePos(self.event_tile_pos)
		end
	elseif self.debugLayer then
		self.debugLayer:setVisible(false)
	end
end
return worldMapComDebugInfo
