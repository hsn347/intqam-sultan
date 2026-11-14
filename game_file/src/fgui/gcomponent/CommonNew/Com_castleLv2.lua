local cityltCtrl = include("cityltCtrl")
local buildLogic = include("buildLogic")
local baseComponent = require("fgui.base.baseComponent")
local Com_castleLv2 = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonNew/Com_castleLv2", Com_castleLv2)
function Com_castleLv2:onInit()
end
function Com_castleLv2:onShow()
	self.fields.Text_starLv:setFontSize(self.fields.title:getFontSize())
	self.fields.Text_starLv:setColor(self.fields.title:getColor())
end
function Com_castleLv2:initData(castleLv, starLv)
	self.castleLv = castleLv
	self.starLv = starLv
	self.isShowStar = self.starLv and self.starLv > 0
	self:setBuildStarLv(starLv)
	self:setCastleLv(castleLv)
	if not SoraDFIsRA() then
		if self.isShowStar then
			_UPVALUE4_ = self.isShowStar
			self.isShowStar[1] = self.fields.Text_starLv
			self.isShowStar[2] = self.fields.Sprite_starLv
			self.isShowStar[3] = self.fields.title
			self.isShowStar[4] = self.fields.Image_castle
			if self.isShowStar then
				goto lbl_43
			end
		end
		_UPVALUE2_ = self.isShowStar
		self.isShowStar[1] = self.fields.title
		local self.isShowStar[2], targets = self.fields.Image_castle, self.isShowStar
		::lbl_43::
		local _totalW = 0
		for k, v in ipairs(targets) do
			_totalW = _totalW + v:getWidth()
			v:setPositionX(self:getWidth() - _totalW)
		end
	else
		if self.isShowStar then
			_UPVALUE4_ = self.isShowStar
			self.isShowStar[1] = self.fields.Text_starLv
			self.isShowStar[2] = self.fields.Sprite_starLv
			self.isShowStar[3] = self.fields.title
			self.isShowStar[4] = self.fields.Image_castle
			if self.isShowStar then
				goto lbl_80
			end
		end
		_UPVALUE2_ = self.isShowStar
		self.isShowStar[1] = self.fields.title
		local self.isShowStar[2], targets = self.fields.Image_castle, self.isShowStar
		::lbl_80::
		local _totalW = 0
		for k, v in ipairs(targets) do
			v:setPositionX(_totalW)
			_totalW = _totalW + v:getWidth()
		end
	end
end
function Com_castleLv2:setCastleLv(castleLv)
	local warLv = buildLogic.transformBuildLvToWarLv(castleLv)
	local castleImg = "icon_castle.png"
	if 1 <= warLv then
		castleLv = warLv
		castleImg = "icon_warlevel.png"
	end
	self.fields.Image_castle:setURL(castleImg)
	self.fields.title:setString(tostring(math.min(castleLv, 30)))
	if not self.starLv or self.starLv and self.starLv <= 0 then
		self.fields.title:setPositionX(0)
	end
end
function Com_castleLv2:setBuildStarLv(starLv)
	self.fields.Sprite_starLv:setVisible(self.isShowStar)
	self.fields.Text_starLv:setVisible(self.isShowStar)
	if self.isShowStar then
		self.fields.Sprite_starLv:setSpriteFrame(cityltCtrl.getBuildStarImage(starLv))
		self.fields.Text_starLv:setString(tostring(starLv))
	end
end
function Com_castleLv2:setTextLvColor(color)
	self.fields.title:setColor(color)
	self.fields.Text_starLv:setColor(color)
end
return Com_castleLv2
