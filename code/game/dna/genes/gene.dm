/**
* Gene Datum
*
* domutcheck was getting pretty hairy.  This is the solution.
*
* All genes are stored in a global variable to cut down on memory
* usage.
*
* @author N3X15 <nexisentertainment@gmail.com>
*/

/datum/dna/gene
	// Display name
	var/name="BASE GENE"

	// Probably won't get used but why the fuck not
	var/desc="Oh god who knows what this does."

	var/activation_prob=100 //#Z2

	// Set in initialize()!
	//  What gene activates this?
	var/block=0

	// Any of a number of GENE_ flags.
	var/flags=0

/**
* Is the gene active in this mob's DNA?
*/
/datum/dna/gene/proc/is_active(mob/M)
	return M.active_genes && (type in M.active_genes)

// Return TRUE if we can activate.
// HANDLE MUTCHK_FORCED HERE!
/datum/dna/gene/proc/can_activate(mob/M, flags)
	return FALSE

// Called when the gene activates.  Do your magic here.
/datum/dna/gene/proc/activate(mob/M, connected, flags)
	return

/**
* Called when the gene deactivates.  Undo your magic here.
* Only called when the block is deactivated.
*/
/datum/dna/gene/proc/deactivate(mob/M, connected, flags)
	return

// This section inspired by goone's bioEffects.

/**
* Called in each life() tick.
*/
/datum/dna/gene/proc/OnMobLife(mob/M)
	return

/**
* Called when the mob dies
*/
/datum/dna/gene/proc/OnMobDeath(mob/M)
	return

/**
* Called when the mob says shit
*/
/datum/dna/gene/proc/OnSay(mob/M, message)
	return message

/**
* Called after the mob runs update_icons.
*
* @params M The subject.
* @params g Gender (m or f)
* @params fat Fat? (0 or 1)
*/
/datum/dna/gene/proc/OnDrawUnderlays(mob/M, g, fat)
	return ""


/////////////////////
// BASIC GENES
//
// These just chuck in a mutation and display a message.
//
// Gene is activated:
//  1. If mutation already exists in mob
//  2. If the probability roll succeeds
//  3. Activation is forced (done in domutcheck)
/////////////////////


/datum/dna/gene/basic
	name="BASIC GENE"

	// Mutation to give
	var/mutation=0

	// Trait to give with GENETIC_MUTATION_TRAIT source
	var/trait_mutation = ""

	// Activation probability
	//var/activation_prob=45 //#Z2 not used here anymore, now in /datum/dna/gene

	// Possible activation messages
	var/list/activation_messages=list()

	// Possible deactivation messages
	var/list/deactivation_messages=list()

/datum/dna/gene/basic/can_activate(mob/M,flags)
	if(flags & MUTCHK_FORCED)
		return TRUE
	// Probability check
	return probinj(activation_prob,(flags&MUTCHK_FORCED))

/datum/dna/gene/basic/activate(mob/M)
	if(mutation)
		M.mutations.Add(mutation)
	if(trait_mutation)
		ADD_TRAIT(M, trait_mutation, GENETIC_MUTATION_TRAIT)
	if(activation_messages.len)
		var/msg = pick(activation_messages)
		to_chat(M, "<span class='notice'>[msg]</span>")

/datum/dna/gene/basic/deactivate(mob/M)
	if(mutation)
		M.mutations.Remove(mutation)
	if(trait_mutation)
		REMOVE_TRAIT(M, trait_mutation, GENETIC_MUTATION_TRAIT)
	if(deactivation_messages.len)
		var/msg = pick(deactivation_messages)
		to_chat(M, "<span class='warning'>[msg]</span>")
