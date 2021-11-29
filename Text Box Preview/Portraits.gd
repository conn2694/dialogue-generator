extends Node2D


# for the first time portraits come in
func enterPortraits(portraitsData):
	if (portraitsData.empty()):
		return
	get_node("Lt 1").enterScene(portraitsData["Lt 1"] if portraitsData.has("Lt 1") else {})
	get_node("Lt 2").enterScene(portraitsData["Lt 2"] if portraitsData.has("Lt 2") else {})
	get_node("Rt 1").enterScene(portraitsData["Rt 1"] if portraitsData.has("Rt 1") else {})
	get_node("Rt 2").enterScene(portraitsData["Rt 2"] if portraitsData.has("Rt 2") else {})
	
func initReactions(portraitsData):
	if (portraitsData.empty()):
		return
	get_node("Lt 1").initialReaction(portraitsData["Lt 1"] if portraitsData.has("Lt 1") else {})
	get_node("Lt 2").initialReaction(portraitsData["Lt 2"] if portraitsData.has("Lt 2") else {})
	get_node("Rt 1").initialReaction(portraitsData["Rt 1"] if portraitsData.has("Rt 1") else {})
	get_node("Rt 2").initialReaction(portraitsData["Rt 2"] if portraitsData.has("Rt 2") else {})

# for when the box is about to end and we want to do a final exit
func exitPortraits(portraitsData):
	get_node("Lt 1").exitBox(portraitsData["Lt 1"] if portraitsData.has("Lt 1") else {})
	get_node("Lt 2").exitBox(portraitsData["Lt 2"] if portraitsData.has("Lt 2") else {})
	get_node("Rt 1").exitBox(portraitsData["Rt 1"] if portraitsData.has("Rt 1") else {})
	get_node("Rt 2").exitBox(portraitsData["Rt 2"] if portraitsData.has("Rt 2") else {})
	

func checkLeavePortraits(portraitsData):
	get_node("Lt 1").exitScene(portraitsData["Lt 1"] if portraitsData.has("Lt 1") else {})
	get_node("Lt 2").exitScene(portraitsData["Lt 2"] if portraitsData.has("Lt 2") else {})
	get_node("Rt 1").exitScene(portraitsData["Rt 1"] if portraitsData.has("Rt 1") else {})
	get_node("Rt 2").exitScene(portraitsData["Rt 2"] if portraitsData.has("Rt 2") else {})
	
# for switching and updating done inbetween
func updatePortraits(portraitsData):
	get_node("Lt 1").updatePortrait(portraitsData["Lt 1"] if portraitsData.has("Lt 1") else {})
	get_node("Lt 2").updatePortrait(portraitsData["Lt 2"] if portraitsData.has("Lt 2") else {})
	get_node("Rt 1").updatePortrait(portraitsData["Rt 1"] if portraitsData.has("Rt 1") else {})
	get_node("Rt 2").updatePortrait(portraitsData["Rt 2"] if portraitsData.has("Rt 2") else {})
	
func loadTextures(portraitsData):
	get_node("Lt 1").updateSprite(portraitsData["Lt 1"] if portraitsData.has("Lt 1") else {})
	get_node("Lt 2").updateSprite(portraitsData["Lt 2"] if portraitsData.has("Lt 2") else {})
	get_node("Rt 1").updateSprite(portraitsData["Rt 1"] if portraitsData.has("Rt 1") else {})
	get_node("Rt 2").updateSprite(portraitsData["Rt 2"] if portraitsData.has("Rt 2") else {})
	
# for checking if characters are on screen
func charactersActive(portraitsData):
	if (get_node("Lt 1").characterActive(portraitsData["Lt 1"] if portraitsData.has("Lt 1") else {})): return true
	elif (get_node("Lt 2").characterActive(portraitsData["Lt 2"] if portraitsData.has("Lt 2") else {})): return true
	elif (get_node("Rt 1").characterActive(portraitsData["Rt 1"] if portraitsData.has("Rt 1") else {})): return true
	elif (get_node("Rt 2").characterActive(portraitsData["Rt 2"] if portraitsData.has("Rt 2") else {})): return true
	else: return false
	
# if multiple characters are leaving at a time at the end of a box, we want to calculate 
# which one is the longest and use that to delay the next box
func getLongestSlideOff(portraitsData):
	var length
	length = get_node("Lt 1").getSpeed(portraitsData["Lt 1"] if portraitsData.has("Lt 1") else {})
	length = max(length, get_node("Lt 2").getSpeed(portraitsData["Lt 2"] if portraitsData.has("Lt 2") else {}))
	length = max(length, get_node("Rt 1").getSpeed(portraitsData["Rt 1"] if portraitsData.has("Rt 1") else {}))
	length = max(length, get_node("Rt 2").getSpeed(portraitsData["Rt 2"] if portraitsData.has("Rt 2") else {}))
	return length
	
