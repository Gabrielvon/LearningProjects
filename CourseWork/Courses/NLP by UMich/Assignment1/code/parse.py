# import sys

# from providedcode.transitionparser import TransitionParser
# from providedcode.dependencygraph import DependencyGraph


# def handle_input(input_file, model_file):
#     tp = TransitionParser.load(model_file)
#     for line in input_file:
#         sentence = DependencyGraph.from_sentence(line)
#         parsed = tp.parse([sentence])
#         print parsed[0].to_conll(10).encode('utf-8')


# if __name__ == '__main__':
#     assert len(sys.argv) == 2, 'Usage: parse.py path_to.model'
#     handle_input(sys.stdin, sys.argv[1])


from providedcode.transitionparser import TransitionParser
from providedcode.dependencygraph import DeendencyGraph
import fileinput
import sys
# parsing arbitrary sentences (english):
import nltk
from nltk.tag import map_tag

if __name__ == '__main__':
    if(len(sys.argv) != 2):
        print "need 1 argument for model!"
        exit(1)

    tp = TransitionParser.load(sys.argv[1])
    line = sys.stdin.readline()
    while line:

        sentence = DependencyGraph.from_sentence(line)
        for (index, node) in enumerate(sentence.nodes):
            sentence.nodes[index]['ctag'] = map_tag('en-ptb', 'universal', sentence.nodes[index]['ctag'])

        parsed = tp.parse([sentence])
        print parsed[0].to_conll(10).encode('utf-8')
        line = sys.stdin.readline()    