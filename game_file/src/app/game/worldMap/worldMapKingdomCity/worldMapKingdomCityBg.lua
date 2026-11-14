local worldMapKingdomCityBg = class("worldMapKingdomCityBg", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapKingdomCityBg")
	end
	return target
end)
function worldMapKingdomCityBg:ctor()
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	SoraDGetChildByName(self, "Image_tile_tl"):setFillType(1)
	SoraDGetChildByName(self, "Image_tile_tr"):setFillType(1)
end
return worldMapKingdomCityBg
