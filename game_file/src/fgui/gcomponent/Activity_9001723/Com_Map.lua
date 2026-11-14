local activity_9001723_Read = include("activity_9001723_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_Map = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001723/Com_Map", Com_Map)
function Com_Map:onInit()
	self:setZoomEnable(true)
	self.scrollPane = self:getScrollPane()
	self.scrollPane:AddEventListener1(fgui.UIEventType.onScrollViewDidZoom, handler(self, self.onZoomScale))
	fguiHelper.registMouseEvent(self)
	self.fields.bigClick:addClickListener(handler(self, self.onClickBg))
end
function Com_Map:onShow()
	self:setButtonsVisible(true)
	self.fields.prefabEx:setEffectPath("fx_11znq_bgfx.prefab")
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.initData))
	end
	self.fields.cover:setVisible(not IsArClient)
end
function Com_Map:onExit(...)
	Com_Map.super.onExit(self)
	self.timer = nil
end
function Com_Map:onClickBg(context)
	local scale = self:getZoomScale()
	local screenPos = cc.p(context.inputEvent.x, context.inputEvent.y)
	self:scrollToCenter(self.fields.bigClick:GlobalToLocal(screenPos) * scale, 0.3)
	local seq = ffa.seq(ffa.delay(0.3), ffa.callFunc(function()
		self:setZoomScaleInDuration(self.maxScale, 0.2)
	end))
	seq:setTag(9001723)
	self:stopActionByTag(9001723)
	self:runAction(seq)
end
function Com_Map:initZoomParam(actualHeight)
	local minScale = actualHeight / 1920
	self:setMinScale(minScale)
	self.maxScale = minScale / 0.6
	self:setMaxScale(self.maxScale)
	self:setZoomScale(self.maxScale)
end
function Com_Map:initData()
	local jumps = activity_9001723_Read:getJumps()
	for k, v in pairs(jumps) do
		local comTitle = self.fields["title" .. v.index]
		if comTitle then
			comTitle:initData(v)
		else
			print("Com_TenYearSingle not found for index: " .. v.index)
		end
	end
end
function Com_Map:onZoomScale()
	local scale = self:getZoomScale()
	if scale >= self.maxScale then
	else
	end
end
function Com_Map:onScroll()
end
function Com_Map:setButtonsVisible(visible)
	self.fields.gTitle:setVisible(visible)
end
return Com_Map
