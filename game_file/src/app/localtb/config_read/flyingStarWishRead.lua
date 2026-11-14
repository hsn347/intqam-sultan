local flyingStarWishRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "giftgivingitem"
;(nil)[2] = true
flyingStarWishRead:defineValue("giftgivingitem", nil)
_UPVALUE2_ = nil
;(nil)[1] = "giftgivingquest"
;(nil)[2] = true
flyingStarWishRead:defineValue("giftgivingquest", nil)
function flyingStarWishRead.getGiftItemConfig()
	return flyingStarWishRead.giftgivingitem
end
function flyingStarWishRead.getTaskConfig()
	return flyingStarWishRead.giftgivingquest
end
return flyingStarWishRead
