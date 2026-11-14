local _ENV, chatemotioninfo
for i = 1, 33 do
	local id = string.format("chat_face_%d", i)
	local img = string.format("chat_face_%d.png", i)
	_ENV = nil
	;(nil).id = id
	;(nil).img = img
	table.insert(chatemotioninfo, i, nil)
end
return chatemotioninfo
