#!/usr/bin/env julia
# my Julia implementation of rake 

include( "Rake.jl" )
importall Rake

test = true
if test
    txt = """ Hello, cat.
        Cat which go to wall.
        Привет, кот.
        Кот, который идет по стене.
        Котам здесь не место.
        Стену мыть. """
else    
    txt = STDIN|>readstring
end    

if basename(PROGRAM_FILE)=="rake.jl" 
    # run as script:
    sentences = split_sentences(txt)
    stoppath = "SmartStoplist.txt"
    
    minchars=parse(Int, ARGS[1])
    maxwords=parse(Int, ARGS[2])
    minfreq=parse(Int, ARGS[3])
    head=parse(Int, ARGS[4])
    
    debug = true
    if debug
        info(minchars); info(maxwords); info(minfreq); info(head)
        
        wdlist = readwords(stoppath); info(wdlist)
        stopwordpattern = stop_word_regex(wdlist); info(stopwordpattern)
        prases = generate_candidate_keywords(sentences, stopwordpattern); info(prases)
        wordscores = calculate_word_scores(prases); info(wordscores)
        kwcandidates = generate_candidate_keyword_scores(prases, wordscores); info(kwcandidates)
        sorted_keywords = sort([ (k,v) for (k,v) in kwcandidates], by=_->_[2], rev=true); info(sorted_keywords)
        total_keywords = length(sorted_keywords); info(total_keywords)
        
    end    
    
    run_rake = init_rake(stoppath, min_char_length=minchars, max_words=maxwords, min_keyword_frequency=minfreq)
    keywords = run_rake(txt)
    for kv in take(keywords,head)
        println(kv)
    end    
end