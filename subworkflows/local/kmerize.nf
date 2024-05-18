//
// Subworkflow with functionality specific to the nf-core/kmerseek pipeline
//

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT FUNCTIONS / MODULES / SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { SOURMASH_SKETCH_DYNAMIC_KSIZE } from '../../modules/local/sourmash/sketch_dynamic_ksize'

/*
========================================================================================
    SUBWORKFLOW TO INITIALISE PIPELINE
========================================================================================
*/

workflow KMERIZE {

    take:
    proteins           // meta, fasta: Path to input fasta file
    alphabet           // string: Alphabet of the input sequences (dna, protein, dayhoff, hp)
    ksizes             // string: k=\d+,k=\d+ k-mer sizes to use

    main:

    ch_versions = Channel.empty()

    view(proteins)


    SOURMASH_SKETCH_DYNAMIC_KSIZE (
        proteins,
        alphabet,
        ksizes,
    )

    ch_versions = ch_versions.mix(SOURMASH_SKETCH_DYNAMIC_KSIZE.out.versions)

    // TODO: Add `sourmash sig describe` to get # kmers and other info about the signature to send to MultiQC
    // TODO: Add sig2kmer here maybe? Or maybe do that all later
    // TODO: Add k-mer counting with Sourmash NodeGraph here

    emit:
    signatures = SOURMASH_SKETCH_DYNAMIC_KSIZE.out.signatures
    versions    = ch_versions
}