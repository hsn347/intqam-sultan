local mainCityABMManager = class("mainCityABMManager")
local CriwareAdxDef = include("criwareAdxDef")
local cityCtrl = SoraDGetCtrl("cityCtrl")
_ENV, _ENV = nil, "cityCtrl"
;(nil).name = "Waterfall"
;(nil).pos = cc.p(1700, 2100)
_ENV, ("cityCtrl").Waterfall, (nil).tag = nil, nil, 1
;(nil).name = "Desert"
;(nil).pos = cc.p(4526, 2413)
_ENV, ("cityCtrl").Desert, (nil).tag = nil, nil, 2
;(nil).name = "Beach"
;(nil).pos = cc.p(4480, 1700)
_ENV, ("cityCtrl").Beach, (nil).tag = nil, nil, 3
;(nil).name = "Bird"
;(nil).pos = cc.p(2570, 1450)
_ENV, ("cityCtrl").Bird, (nil).tag = nil, nil, 4
;(nil).name = "Pyramids_gold"
;(nil).pos = cc.p(4900, 2100)
;("cityCtrl").Pyramids_gold, (nil).tag = nil, 5
local ABMPOS = "cityCtrl"
local SCALE_HIGHT = 200
function mainCityABMManager:init(mainCityView)
end
function mainCityABMManager:scrollViewDidZoom(mainCityView)
	local scale = mainCityView.viewScrollView:getZoomScale()
	if scale == self.curScale then
		return
	end
	self.curScale = scale
	self.zoomScale = (self.curScale - mainCityView.minScale) / (mainCityView.maxScale - mainCityView.minScale)
	print("self.curScale ==== ", self.curScale)
	print("self.zoomScale ==== ", self.zoomScale)
	self:updateListionerPosition()
	local itemScale = 1
	if self.curScale and self.curScale < MAINCITY_DEFAULT_SCALE then
		itemScale = 1 + 0.5 * (MAINCITY_DEFAULT_SCALE - self.curScale) / (MAINCITY_DEFAULT_SCALE - mainCityView.minScale)
	end
	_ENV = MAINCITY_DEFAULT_SCALE - mainCityView.minScale
	;(MAINCITY_DEFAULT_SCALE - mainCityView.minScale).msg = "MESSAGE_MAINCITYVIEW_SCALE_CHANGE"
	;(MAINCITY_DEFAULT_SCALE - mainCityView.minScale).scale = self.curScale
	SoraDSendMessage(MAINCITY_DEFAULT_SCALE - mainCityView.minScale)
end
function mainCityABMManager:scrollViewDidOffset(mainCityView)
	local containerView = mainCityView.containerView
	if not self.curPos then
		self.curPos = cc.p(display.width / 2, display.height / 2)
	else
		self.curPos.x = display.width / 2
		self.curPos.y = display.height / 2
	end
	local nodePos = containerView:convertToNodeSpace(self.curPos)
	if nodePos.x == self.curPos.x and nodePos.y == self.curPos.y then
		return
	end
	self.curPos = nodePos
	self:updateListionerPosition()
end
function mainCityABMManager:updateListionerPosition()
	if self.zoomScale == nil or self.curPos == nil or self.isPause then
		return
	end
	if not self.isPlaying then
		self.soundIds, _ENV = self.isPlaying, self.isPlaying
		for k, v in pairs(ABMPOS) do
			print("playABM ====", v.name)
			local soundId = SoraDPlaySound("maincityABM", v.name, nil, v.tag)
			table.insert(self.soundIds, soundId)
			criAdxMgr:set3DSourcePos(v.tag, v.pos.x, v.pos.y, 300)
		end
		self.isPlaying = true
	end
	criAdxMgr:set3DListionerPos(self.curPos.x, self.curPos.y, (1 - self.zoomScale) * SCALE_HIGHT)
end
function mainCityABMManager:pauseCurABM()
	self.isPause = true
	if self.isPlaying then
		for i, v in ipairs(self.soundIds) do
			AudioEngine.stopEffect(v)
		end
		self.isPlaying = false
	end
end
function mainCityABMManager:resumeCurABM()
	self.isPause = false
	self:updateListionerPosition()
end
return mainCityABMManager
