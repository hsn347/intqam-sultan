local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local lordLocalData = include("lordLocalData")
local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local atlantisPersonResultView = class("atlantisPersonResultView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("atlantisPersonResultView")
	end
	return target
end)
function atlantisPersonResultView:ctor()
	self.enableTouchCloseSelf = true
	self:initWidget()
end
function atlantisPersonResultView:test(...)
	_UPVALUE0_ = nil
	self:initData(nil)
end
function atlantisPersonResultView:initWidget(...)
	SoraDGetAllChildFromWidget(self._ccsView, self)
	SoraDCreatAnimation(self.__cname, self._ccsView, true)
	self.Button_close:addTouchEventListener(handler(self, self.close))
	lordLocalData = handler(self, self.close)
	handler(self, self.close)[1] = "ar"
	handler(self, self.close)[2] = "en"
	local icon = SoraDGetImageNameByLang("frame_shmc_grtj_%s.png", handler(self, self.close))
	self.Sprite_title:setSpriteFrame(icon)
	self.Text_rank:setString(i18n("common_text_2193"))
	local imageId = lordInfoCtrl:getLordInfo().base.imageId
	self.Sprite_bust:setSpriteFrame(lordLocalData.getPortrait(imageId))
	self:fitView()
end
function atlantisPersonResultView:fitView(...)
	local scale = math.min(1, display.height / 1136)
	local showH = 788
	local posyScale = 203 / (1136 - showH)
	if scale < 1 then
		self.Node_show:setScale(scale)
	end
	local posy = (display.height - showH * scale) * posyScale
	self.Node_score:setPositionY(posy)
end
function atlantisPersonResultView:initData(data)
	local rank = data.rank or 0
	self.BitmapFontLabel_1:setString(rank)
	local killBossScore = data.killBossScore or 0
	local killPlayerScore = data.killPlayerScore or 0
	local occupyScore = data.occupyScore or 0
	local totalScore = killBossScore + killPlayerScore + occupyScore
	local scoreWeight = atlantisWarCtrl:getScoreWeight()
	if scoreWeight then
		totalScore = math.floor(totalScore * scoreWeight)
	end
	atlantisWarCtrl, _UPVALUE4_ = totalScore * scoreWeight, math.floor(totalScore * scoreWeight)
	;(totalScore * scoreWeight).name = "atlantiswar_text_0179"
	atlantisWarCtrl, (totalScore * scoreWeight).score = nil, totalScore
	;(nil).name = "atlantiswar_text_0180"
	atlantisWarCtrl, (nil).score = nil, killBossScore
	;(nil).name = "atlantiswar_text_0129"
	atlantisWarCtrl, (nil).score = nil, killPlayerScore
	;(nil).name = "atlantiswar_text_0182"
	;(nil).score = occupyScore
	math.floor(totalScore * scoreWeight)[1] = totalScore * scoreWeight
	math.floor(totalScore * scoreWeight)[2] = nil
	math.floor(totalScore * scoreWeight)[3] = nil
	local math.floor(totalScore * scoreWeight)[4], config = nil, math.floor(totalScore * scoreWeight)
	for i, v in ipairs(config) do
		self["Text_key" .. i]:setString(i18n(v.name))
		self["Text_value" .. i]:setString(string.formatnumberthousands(v.score))
	end
end
return atlantisPersonResultView
