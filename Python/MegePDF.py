import PyPDF2
import os

def merge_pdfs(pdf_list, output_path):
    pdf_writer = PyPDF2.PdfWriter()

    for pdf in pdf_list:
        pdf_reader = PyPDF2.PdfReader(pdf)
        for page in range(len(pdf_reader.pages)):
            pdf_writer.add_page(pdf_reader.pages[page])

    with open(output_path, 'wb') as out_file:
        pdf_writer.write(out_file)

if __name__ == "__main__":
    folder_path = r'E:\GitHub\sptrains\my-son-learning-journal\Worksheets\Kindergarten\Other Activities\Different'  # Use raw string
    output_file = r'C:\Users\SANKAR REDDY\Desktop\New folder\Different.pdf'  # Output file path

    # Get a list of all PDF files in the specified folder
    pdf_files = [os.path.join(folder_path, f) for f in os.listdir(folder_path) if f.endswith('.pdf')]

    # Check if any PDF files were found
    if not pdf_files:
        print(f"No PDF files found in {folder_path}.")
    else:
        merge_pdfs(pdf_files, output_file)
        print(f'Merged {len(pdf_files)} PDFs into {output_file}.')
